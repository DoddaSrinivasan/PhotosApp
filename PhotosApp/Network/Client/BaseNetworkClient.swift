//
//  BaseNetworkClient.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol
    func finishTasksAndInvalidate()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completion)) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol NetworkClient {
    var session: URLSessionProtocol {get set}
}

enum NetworkErrors: Error {
    case MalFormedUrlError
    case DataDeSerilizationError
}
