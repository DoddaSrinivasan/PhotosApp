//
//  MockCacheableClient.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockCacheableClient: DownloadProtocol {
    
    private (set) var requestedUrl: URL?
    private (set) var responndWithUrl: URL?
    private let data: Data?
    private let error: Error?
    
    init(responndWithUrl: URL?, data: Data?, error: Error?){
        self.responndWithUrl = responndWithUrl
        self.data = data
        self.error = error
    }
    
    func downloadUrl(url: URL?, callback: @escaping (URL?, Data?, Error?) -> Void) {
        callback(responndWithUrl, data, error)
    }
}
