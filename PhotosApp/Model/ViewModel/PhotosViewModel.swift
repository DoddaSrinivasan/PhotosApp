//
//  PhotosViewModel.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

protocol PhotosView {
    func showPhotos()
    func showMessage(_ message: String)
    func showALertTitle(_ title: String, message: String)
    
    func pickPhotoFromCamera()
    func pickPhotoFromGallary()
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
        self.photosView.showMessage("Loading...".localised)
        photosApi.getPhotos { [weak self] (photos, error) in
            guard error == nil else {
                self?.photosView.showMessage(error?.message ?? "Something went wrong. Try again later".localised)
                return
            }
            
            self?.photos = (photos ?? [])
                .filter({ (photo) -> Bool in
                    return photo.isValid()
                })
                .map({ (photo) -> PhotoViewModel in
                    let url = self?.imagesEndpoints.imageEndpoint(imageId: photo.photoId!)
                    let aspectRatio = Float(photo.height!)/Float(photo.width!)
                    return PhotoViewModel(photoUrl: url, aspectRatio: aspectRatio)
                })
        }
    }
    
    func uploadImage(_ imageData: Data) {
        photosApi.uploadPhoto(imageData) { [weak self] (photo, error) in
            guard error == nil,
                let photo = photo,
                photo.isValid() else {
                self?.photosView.showALertTitle("Upload Failed".localised,
                                                message: error?.message ?? "Something went wrong. Try again later".localised)
                return
            }
            
            let url = self?.imagesEndpoints.imageEndpoint(imageId: photo.photoId!)
            let aspectRatio = Float(photo.height!)/Float(photo.width!)
            self?.photos.append(PhotoViewModel(photoUrl: url, aspectRatio: aspectRatio))
        }
    }
}

extension PhotosViewModel {
    
    func choosePhotoFromGallary(with permission: PhotoLibraryPermission.Type) {
        switch permission.authorizationStatus() {
        case .authorized:
            photosView.pickPhotoFromGallary()
        case .notDetermined:
            permission.requestAccess { [weak self] granted in
                if granted {
                    self?.photosView.pickPhotoFromGallary()
                }
            }
        case .denied:
            photosView.showALertTitle("Permission Required".localised, message: "Please go to Setting and provide Photo Library Permission".localised)
        case .restricted:
            return
        }
    }
    
    func choosePhotoFromCamera(with permission: CameraPermission.Type) {
        switch permission.cameraAuthorizationStatus() {
        case .authorized:
            photosView.pickPhotoFromCamera()
        case .notDetermined:
            permission.requestCameraAccess { [weak self] granted in
                if granted {
                    self?.photosView.pickPhotoFromCamera()
                }
            }
        case .denied:
            photosView.showALertTitle("Permission Required".localised, message: "Please go to Setting and provide Camera Permission".localised)
        case .restricted:
            return
        }
    }
    
}
