//
//  MockHttpClient.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockHttpClient: HTTPClientProtocol {
    
    private (set) var url: URL?
    private (set) var httpBody: Data?
    private (set) var headers: [String : String]?
    
    private let data: Decodable?
    private let error: Error?
    
    init(data: Decodable?, error: Error?){
        self.data = data
        self.error = error
    }
    
    func get<T: Decodable>(url: URL?, type: T.Type, callback: @escaping (T?, Error?) -> Void) {
        self.url = url
        callback(data as? T, error)
    }
    
    func post<T: Decodable>(url: URL?, body: Data, headers: [String : String], type: T.Type, callback: @escaping (T?, Error?) -> Void) {
        self.url = url
        self.httpBody = body
        self.headers = headers
        callback(data as? T, error)
    }
}
