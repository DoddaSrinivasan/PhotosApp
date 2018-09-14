//
//  PhotosViewModel.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

protocol PhotosView {
    func showPhotos()
    func showMessage(message: String)
}

class PhotosViewModel {
    
    private let photosView: PhotosView
    private let photosApi: PhotosAPIProtocol
    private let imagesEndpoints: PhotosEndPoints
    
    private (set) var photos: [PhotoViewModel] = [] {
        didSet {
            photosView.showPhotos()
        }
    }
    
    init(photosView: PhotosView, photosApi: PhotosAPIProtocol, imagesEndpoints: PhotosEndPoints) {
        self.photosView = photosView
        self.photosApi = photosApi
        self.imagesEndpoints = imagesEndpoints
    }
    
    convenience init(photosView: PhotosView) {
        self.init(photosView: photosView, photosApi: PhotosAPI(), imagesEndpoints: PhotosEndPoints())
    }
    
    func loadPhotos() {
        photosApi.getPhotos { [weak self] (photos, error) in
            guard error == nil else {
                self?.photosView.showMessage(message: error?.message ?? "Something went wrong")
                return
            }
            
            self?.photos = (photos ?? [])
                .filter({ (photo) -> Bool in
                    return photo.photoId != nil && photo.width != nil && photo.height != nil
                })
                .map({ (photo) -> PhotoViewModel in
                    let url = self?.imagesEndpoints.imageEndpoint(imageId: photo.photoId!)
                    let aspectRatio = Float(photo.height!)/Float(photo.width!)
                    return PhotoViewModel(photoUrl: url, aspectRatio: aspectRatio)
                })
        }
    }
    
}
