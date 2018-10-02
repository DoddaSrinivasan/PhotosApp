//
//  MockPhotoPreviewView.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation
@testable import PhotosApp

class MockPhotoPreviewView: PhotosPreviewView {
    
    private (set) var selectedPhotoIndex: Int?
    private (set) var selectedIndicatorIndex: Int?
    
    func setSelectedPhoto(index: Int) {
        self.selectedPhotoIndex = index
    }
    
    func setSelectedIndicator(index: Int) {
        self.selectedIndicatorIndex = index
    }
    

}
