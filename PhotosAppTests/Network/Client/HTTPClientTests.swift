//
//  HTTPClientTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

struct SampleResponse: Decodable {
    var code: Int?
}

class HTTPClientTests: XCTestCase {
    
    func testShouldCompleteWithErrorForMalformetUrl() {
        let mockUrlString = "Some url"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:nil, dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in
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
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in}
        
        XCTAssertNil(mockSession.url)
        XCTAssert(!mockDataTask.isResumeCalled)
    }
    
    func testShouldCompleteWithErrorIfDataIsNil() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:NSError(domain: "DOMAIN", code: 0, userInfo:nil), dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
        
        XCTAssert(mockSession.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
    }
    
    func testShouldCompleteWithErrorIfDataIsNotJsonJSONSerializable() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: "Some Data".data(using: .utf8),
                                         error: nil,
                                         dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in
            let httpError = error as? NetworkErrors
            XCTAssertNil(data)
            XCTAssertNotNil(httpError)
            XCTAssert(httpError! == NetworkErrors.DataDeSerilizationError)
        }
        
        XCTAssert(mockSession.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
    }
    
    func testShouldCompleteWithData() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: "{}".data(using: .utf8),
                                         error: nil,
                                         dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        
        XCTAssert(mockSession.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
    }
}

