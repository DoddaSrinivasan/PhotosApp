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
    
    private (set) var imageData: Data?
    
    init(data: T?, apiError: APIError?) {
        self.data = data
        self.apiError = apiError
    }
    
    func getPhotos(callback: @escaping ([Photo]?, APIError?) -> Void) {
        callback(data as? [Photo], apiError)
    }
    
    func uploadPhoto(_ imageData: Data, callback: @escaping (Photo?, APIError?) -> Void) {
        self.imageData = imageData
        callback(data as? Photo, apiError)
    }
}
