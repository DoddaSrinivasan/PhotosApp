//
//  PhotosEndPoints.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

class PhotosEndPoints {
    
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    convenience init() {
        self.init(scheme: AlbumServiceApiConfig.scheme, host: AlbumServiceApiConfig.host)
    }
    
    func getPhotosEndPoint() -> URL? {
        var photosURLComponents = URLComponents()
        photosURLComponents.scheme = scheme
        photosURLComponents.host = host
        photosURLComponents.path = "/photos"
        
        return photosURLComponents.url
    }
    
    func imageEndpoint(imageId: String) -> URL? {
        var photoImageURLComponents = URLComponents()
        photoImageURLComponents.scheme = scheme
        photoImageURLComponents.host = host
        photoImageURLComponents.path = "/images/\(imageId).png"
        
        return photoImageURLComponents.url
    }
    
}
