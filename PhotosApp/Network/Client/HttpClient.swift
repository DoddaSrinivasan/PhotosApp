//
//  HttpClient.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

class HttpClient: NetworkClient {
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
}

protocol HTTPClientProtocol {
    func get<T: Decodable>(url: URL?, type: T.Type, callback: @escaping ( _ data: T?, _ error: Error?) -> Void)
    func post<T: Decodable>(url: URL?, body: Data, headers: [String: String], type: T.Type, callback: @escaping ( _ data: T?, _ error: Error?) -> Void)
}

extension HttpClient: HTTPClientProtocol {
    
    func get<T: Decodable>(url: URL?, type: T.Type, callback: @escaping ( _ data: T?, _ error: Error?) -> Void) {
        guard let _ = url else {
            callback(nil, NetworkErrors.MalFormedUrlError)
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        execute(request: request, type: type, callback: callback)
    }
    
    func post<T: Decodable>(url: URL?, body: Data, headers: [String: String], type: T.Type, callback: @escaping ( _ data: T?, _ error: Error?) -> Void) {
        guard let _ = url else {
            callback(nil, NetworkErrors.MalFormedUrlError)
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        for (headerField, value) in headers {
            request.addValue(value, forHTTPHeaderField: headerField)
        }
        request.httpBody = body
        
        execute(request: request, type: type, callback: callback)
    }
    
    func execute<T: Decodable>(request: URLRequest, type: T.Type, callback: @escaping ( _ data: T?, _ e: Error?) -> Void) {
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async { 
                guard let data = data, error == nil else {
                    callback(nil, error)
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(type, from: data)
                    callback(decodedObject, nil)
                } catch {
                    callback(nil, NetworkErrors.DataDeSerilizationError)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
