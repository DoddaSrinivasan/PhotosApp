//
//  PhotosAPI.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

protocol PhotosAPIProtocol {
    func getPhotos(callback: @escaping ( _ photos: [Photo]?, _ error: APIError?) -> Void)
}

class PhotosAPI: PhotosAPIProtocol {

    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    convenience init() {
        self.init(httpClient: HttpClient())
    }
    
    func getPhotos(callback: @escaping ([Photo]?, APIError?) -> Void) {
        let photosUrl = PhotosEndPoints().getPhotosEndPoint()
        self.httpClient.get(url: photosUrl, type: ServiceResponse<[Photo]>.self) { (response, error) in
            guard let data = response, error == nil else {
                callback(nil, APIError(message: "Something went wrong. Try again later".localised))
                return
            }
            
            guard data.error == nil else {
                callback(nil, data.error)
                return
            }
            
            callback(data.content, nil)
        }
    }
}
