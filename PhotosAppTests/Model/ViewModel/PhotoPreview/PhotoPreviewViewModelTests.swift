//
//  PhotoPreviewViewModelTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotoPreviewViewModelTests: XCTestCase {
    
    
    func testShouldSyncronizePhotosWithSelectedIndex() {
        let mockView = MockPhotoPreviewView()
        let photos = getPhotos()
        
        let viewModel = PhotosPreviewViewModel(view: mockView, photos: photos, selectedIndex: 1)
        viewModel.syncronizePhotos()
        
        XCTAssert(mockView.selectedPhotoIndex == 1)
    }
    
    func testShouldSyncronizeIndicatorWithSelectedIndex() {
        let mockView = MockPhotoPreviewView()
        let photos = getPhotos()
        
        let viewModel = PhotosPreviewViewModel(view: mockView, photos: photos, selectedIndex: 1)
        viewModel.syncronizePageIndicator()
        
        XCTAssert(mockView.selectedIndicatorIndex == 1)
    }
    
    func testShouldSyncronizeIndicatorWithSelectedIndexChange() {
        let mockView = MockPhotoPreviewView()
        let photos = getPhotos()
        
        let viewModel = PhotosPreviewViewModel(view: mockView, photos: photos, selectedIndex: 1)
        viewModel.setSelectedIndex(index: 2)
        
        XCTAssert(mockView.selectedIndicatorIndex == 2)
    }
    
    private func getPhotos() -> [PhotoViewModel] {
        let photo1 = PhotoViewModel(photoUrl: nil, aspectRatio: 0.1)
        let photo2 = PhotoViewModel(photoUrl: nil, aspectRatio: 0.2)
        let photo3 = PhotoViewModel(photoUrl: nil, aspectRatio: 0.3)
        let photo4 = PhotoViewModel(photoUrl: nil, aspectRatio: 0.4)
        
        return [photo1, photo2, photo3, photo4]
    }
}
