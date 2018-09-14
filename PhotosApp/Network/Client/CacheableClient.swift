//
//  CacheableClient.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

class CacheableClient: NetworkClient {
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    convenience init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = URLCache.shared
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        self.init(session: URLSession(configuration: sessionConfiguration))
    }
}

protocol DownloadProtocol {
    func downloadUrl(url: URL?, callback: @escaping (_ url: URL?, _ data: Data?, _ error: Error?) -> Void)
}

extension CacheableClient: DownloadProtocol {
    
    func downloadUrl(url: URL?, callback: @escaping (URL?, Data?, Error?) -> Void) {
        guard let _ = url else {
            callback(url, nil, NetworkErrors.MalFormedUrlError)
            return
        }
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                callback(url, data, error)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
