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
        
        httpClient.post(url: url, body: Data(), headers: [:], type: SampleResponse.self) { (data, error) in
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
        httpClient.post(url: url, body: Data(), headers: [:], type: SampleResponse.self) { (data, error) in}
        
        XCTAssertNil(mockSession.urlRequest?.url)
        XCTAssert(!mockDataTask.isResumeCalled)
        XCTAssert(!mockSession.isfinishTasksAndInvalidateCalled)
    }
    
    func testShouldMakeGetRequest() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:nil, dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.get(url: url, type: SampleResponse.self) { (data, error) in}
        
        XCTAssert(mockSession.urlRequest?.httpMethod == "GET")
    }
    
    func testShouldMakePostRequest() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:nil, dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.post(url: url, body: Data(), headers: ["KEY": "VALUE"], type: SampleResponse.self) { (data, error) in}
        
        XCTAssert(mockSession.urlRequest?.httpMethod == "POST")
        XCTAssert(mockSession.urlRequest?.value(forHTTPHeaderField: "KEY") == "VALUE")
        XCTAssertNotNil(mockSession.urlRequest?.httpBody)
    }
    
    func testShouldCompleteWithErrorIfDataIsNil() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let request = URLRequest(url: url!)
        
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: nil, error:NSError(domain: "DOMAIN", code: 0, userInfo:nil), dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.execute(request: request, type: SampleResponse.self) { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
        }
        
        XCTAssert(mockSession.urlRequest?.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
        XCTAssert(mockSession.isfinishTasksAndInvalidateCalled)
    }
    
    func testShouldCompleteWithErrorIfDataIsNotJsonJSONSerializable() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let request = URLRequest(url: url!)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: "Some Data".data(using: .utf8),
                                         error: nil,
                                         dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.execute(request: request, type: SampleResponse.self) { (data, error) in
            let httpError = error as? NetworkErrors
            XCTAssertNil(data)
            XCTAssertNotNil(httpError)
            XCTAssert(httpError! == NetworkErrors.DataDeSerilizationError)
        }
        
        XCTAssert(mockSession.urlRequest?.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
        XCTAssert(mockSession.isfinishTasksAndInvalidateCalled)
    }
    
    func testShouldCompleteWithData() {
        let mockUrlString = "http://someurl.com"
        let url = URL(string: mockUrlString)
        let request = URLRequest(url: url!)
        let mockDataTask = MockUrlSessionDataTask()
        let mockSession = MockUrlSession(data: "{}".data(using: .utf8),
                                         error: nil,
                                         dataTask: mockDataTask)
        let httpClient = HttpClient(session: mockSession)
        
        httpClient.execute(request: request, type: SampleResponse.self) { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        
        XCTAssert(mockSession.urlRequest?.url!.absoluteString == mockUrlString)
        XCTAssert(mockDataTask.isResumeCalled)
        XCTAssert(mockSession.isfinishTasksAndInvalidateCalled)
    }
}

