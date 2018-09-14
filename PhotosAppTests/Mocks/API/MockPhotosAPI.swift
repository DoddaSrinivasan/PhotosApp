//
//  MockPhotosAPI.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockPhotosAPI<T>: PhotosAPIProtocol {
    
    private (set) var data: T?
    private (set) var apiError: APIError?
    
    init(data: T?, apiError: APIError?) {
        self.data = data
        self.apiError = apiError
    }
    
    func getPhotos(callback: @escaping ([Photo]?, APIError?) -> Void) {
        callback(data as? [Photo], apiError)
    }
}
