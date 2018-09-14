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
    private (set) var message: String?
    
    func showPhotos() {
        isShowPhotosCalled = true
    }
    
    func showMessage(message: String) {
        isShowMessageCalled = true
        self.message = message
    }
    
}
