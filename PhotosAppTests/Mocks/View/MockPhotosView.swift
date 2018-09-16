//
//  MockPhotosView.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockPhotosView: PhotosView {
    
    private (set) var isShowPhotosCalled = false
    private (set) var isShowMessageCalled = false
    private (set) var isShowALertCalled = false
    
    private (set) var isPickPhotoFromCameraCalled = false
    private (set) var isPickPhotoFromGallaryCalled = false
    
    private (set) var message: String?
    
    private (set) var alertTitle: String?
    private (set) var alertMessage: String?
    
    func showPhotos() {
        isShowPhotosCalled = true
    }
    
    func showMessage(_ message: String) {
        isShowMessageCalled = true
        self.message = message
    }
    
    func pickPhotoFromCamera() {
        isPickPhotoFromCameraCalled = true
    }
    
    func pickPhotoFromGallary() {
        isPickPhotoFromGallaryCalled = true
    }
    
    func showALertTitle(_ title: String, message: String) {
        isShowALertCalled = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
