//
//  PhotosViewModelTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotosViewModelTests: XCTestCase {
    
    func testShouldShowErrorMessageOnLoadPhotosFailed() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: nil, apiError: APIError(message: "Some Error"))
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.loadPhotos()
        
        XCTAssert(mockView.isShowMessageCalled)
        XCTAssert(mockView.message == "Some Error")
    }
    
    func testShouldShowDefaultErrorMessageOnLoadPhotosFailed() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: nil, apiError: APIError(message: nil))
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.loadPhotos()
        
        XCTAssert(mockView.isShowMessageCalled)
        XCTAssert(mockView.message == "Something went wrong")
    }
    
    func testShouldShowPhotosOnLoadPhotosSuccess() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.loadPhotos()
        
        XCTAssert(mockView.isShowPhotosCalled)
    }
    
    func testShouldShowFilterPhotosWithNoId() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.loadPhotos()
        
        XCTAssert(photosViewModel.photos.count == 3)
        XCTAssert(photosViewModel.photos[0].photoUrl?.absoluteString == "http://host/images/photoId1.png")
        XCTAssert(photosViewModel.photos[1].photoUrl?.absoluteString == "http://host/images/photoId2.png")
        XCTAssert(photosViewModel.photos[2].photoUrl?.absoluteString == "http://host/images/photoId3.png")
    }
    
    
    
    private func photos() -> [Photo] {
        let photo1 = Photo(photoId: "photoId1", width: 1, height: 2)
        let photo2 = Photo(photoId: "photoId2", width: 3, height: 4)
        let photo3 = Photo(photoId: "photoId3", width: 5, height: 6)
        let photo4 = Photo(photoId: nil, width: 7, height: 8)
        
        return [photo1, photo2, photo3, photo4]
    }
    
}
