//
//  CacheableClientTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class CacheableClientTests: XCTestCase {
    
    func testShouldUseCacheingForURLSession() {
        let cacheableClient = CacheableClient()
        let session = cacheableClient.session as! URLSession
        
        XCTAssertNotNil(session.configuration.urlCache)
        XCTAssert(session.configuration.requestCachePolicy == .returnCacheDataElseLoad)
    }
    
    func testShouldCompleteWithErrorForMalformetUrl() {
        let mockUrlString = "Some url"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:nil, dataTask: mockDataTask)
        let cacheableClient = CacheableClient(session: mockSession)
        
        cacheableClient.downloadUrl(url: url) { (url, data, error) in
            let httpError = error as? NetworkErrors
            XCTAssertNil(data)
            XCTAssertNotNil(httpError)
            XCTAssert(httpError! == NetworkErrors.MalFormedUrlError)
        }
    }
    
    func testShouldNotMakeNetworkCallForMalformedUrl() {
        let mockUrlString = "Some url"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:nil, dataTask: mockDataTask)
        let cacheableClient = CacheableClient(session: mockSession)
        
        cacheableClient.downloadUrl(url: url) { (url, data, error) in }
        
        XCTAssertNil(mockSession.url)
        XCTAssert(!mockDataTask.isResumeCalled)
        XCTAssert(!mockSession.isfinishTasksAndInvalidateCalled)
    }
    
    func testShouldCompleteWithDataOrError() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let data = "SomeData".data(using: .utf8)
        let error = NSError(domain: "DOMAIN", code: 0, userInfo:nil)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: data, error: error, dataTask: mockDataTask)
        let cacheableClient = CacheableClient(session: mockSession)
        
        cacheableClient.downloadUrl(url: url) { (responseUrl, responseData, responseError) in
            XCTAssertEqual(url?.absoluteString, responseUrl?.absoluteString)
            XCTAssertEqual(data, responseData)
            XCTAssertNotNil(responseError)
        }
        
        XCTAssert(mockSession.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
        XCTAssert(mockSession.isfinishTasksAndInvalidateCalled)
    }
}
