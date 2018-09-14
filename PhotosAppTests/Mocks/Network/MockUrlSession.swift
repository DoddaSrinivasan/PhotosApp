//
//  MockUrlSession.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockUrlSession: URLSessionProtocol {
    
    private (set) var url: URL?
    private (set) var isfinishTasksAndInvalidateCalled = false
    
    let data: Data?
    let error: Error?
    let dataTask: URLSessionDataTaskProtocol
    
    
    init(data: Data?, error: Error?, dataTask: URLSessionDataTaskProtocol) {
        self.data = data
        self.error = error
        self.dataTask = dataTask
    }
    
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        url = request.url
        completion(data, nil, error)
        return dataTask
    }
    
    func finishTasksAndInvalidate() {
        isfinishTasksAndInvalidateCalled = true
    }
}

class MockUrlSessionDataTask: URLSessionDataTaskProtocol {
    
    private (set) var isResumeCalled = false
    
    func resume() {
        isResumeCalled = true
    }
}
