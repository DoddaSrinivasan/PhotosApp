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
    
    //MARK: Load Photos from API Tests
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
        XCTAssert(mockView.message == "Something went wrong. Try again later".localised)
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
    
    //MARK: UploadPhoto
    
    func testShouldShowUploadIndicatorWhileUploading() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<Photo>()
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let imageDataToUpload = Data()
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(imageDataToUpload)
        
        XCTAssertTrue(mockView.isShowUploaderCalled)
        XCTAssert(mockView.uploadingImageData == imageDataToUpload)
    }
    
    func testShouldHideUploadIndicatorOnUploadFail() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: nil, apiError: APIError(message: "Some Error"))
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(Data())
        
        XCTAssertTrue(mockView.isHideUploaderCalled)
    }
    
    func testShouldHideUploadIndicatorOnUploadSuccess() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<Photo>(data: Photo(photoId: "PhotoId", width: 100, height: 200), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(Data())
        
        XCTAssertTrue(mockView.isHideUploaderCalled)
    }
    
    func testShouldShowErrorMessageOnUploadFailed() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: nil, apiError: APIError(message: "Some Error"))
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(Data())
        
        XCTAssertTrue(mockView.isShowALertCalled)
        XCTAssert(mockView.alertTitle == "Upload Failed".localised)
        XCTAssert(mockView.alertMessage == "Some Error")
    }
    
    func testShouldShowErrorMessageOnUploadInvalid() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<Photo>(data: Photo(photoId: "PhotoId", width: nil, height: 200), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(Data())
        
        XCTAssertTrue(mockView.isShowALertCalled)
        XCTAssert(mockView.alertTitle == "Upload Failed".localised)
        XCTAssert(mockView.alertMessage == "Something went wrong. Try again later".localised)
    }
    
    func testShouldShowPhotosOnUploadSuccess() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<Photo>(data: Photo(photoId: "PhotoId", width: 100, height: 200), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        photosViewModel.uploadImage(Data())

        
        XCTAssert(mockView.isShowPhotosCalled)
        XCTAssert(photosViewModel.photos.count == 1)
    }
    
    
    //MARK: Camera Access and Pick from Camera Tests
    func testShouldAskForCameraPermissionWhenNotDetermined() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockCameraPermission.setStatus(.notDetermined, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromCamera(with: MockCameraPermission.self)
        
        XCTAssertTrue(MockCameraPermission.isCameraAccessRequested)
    }
    
    func testShouldNotDoAnythingWhenCameraAccessIsRequestedAndDenied() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockCameraPermission.setStatus(.notDetermined, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromCamera(with: MockCameraPermission.self)
        
        XCTAssertFalse(mockView.isPickPhotoFromCameraCalled)
    }
    
    func testShouldAskViewToPickFromCameraWhenGranted() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockCameraPermission.setStatus(.notDetermined, grantedWhenAsked: true)
        
        photosViewModel.choosePhotoFromCamera(with: MockCameraPermission.self)
        
        XCTAssertTrue(mockView.isPickPhotoFromCameraCalled)
    }
    
    func testShouldAskViewToPickFromCameraWhenAuthorised() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockCameraPermission.setStatus(.authorized, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromCamera(with: MockCameraPermission.self)
        
        XCTAssertTrue(mockView.isPickPhotoFromCameraCalled)
    }
    
    func testShouldShowAlertRequiringCameraPermissionOnDenied() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockCameraPermission.setStatus(.denied, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromCamera(with: MockCameraPermission.self)
        
        XCTAssertTrue(mockView.isShowALertCalled)
        XCTAssert(mockView.alertTitle == "Permission Required".localised)
        XCTAssert(mockView.alertMessage == "Please go to Setting and provide Camera Permission".localised)
    }
    
    //MARK: PhotoLibrary Access and Pick from Camera Tests
    func testShouldAskForPhotoLibraryPermissionWhenNotDetermined() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockPhotoLibraryPermission.setStatus(.notDetermined, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromGallary(with: MockPhotoLibraryPermission.self)
        
        XCTAssertTrue(MockPhotoLibraryPermission.isPhotoLibraryAccessRequested)
    }
    
    func testShouldNotDoAnythingWhenPhotoLibraryAccessIsRequestedAndDenied() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockPhotoLibraryPermission.setStatus(.notDetermined, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromGallary(with: MockPhotoLibraryPermission.self)
        
        XCTAssertFalse(mockView.isPickPhotoFromGallaryCalled)
    }
    
    func testShouldAskViewToPickFromGallaryWhenGranted() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockPhotoLibraryPermission.setStatus(.notDetermined, grantedWhenAsked: true)
        
        photosViewModel.choosePhotoFromGallary(with: MockPhotoLibraryPermission.self)
        
        XCTAssertTrue(mockView.isPickPhotoFromGallaryCalled)
    }
    
    func testShouldAskViewToPickFromGallaryWhenAuthorised() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockPhotoLibraryPermission.setStatus(.authorized, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromGallary(with: MockPhotoLibraryPermission.self)
        
        XCTAssertTrue(mockView.isPickPhotoFromGallaryCalled)
    }
    
    func testShouldShowAlertRequiringPhotoLibraryPermissionOnDenied() {
        let mockView = MockPhotosView()
        let mockPhotosApi = MockPhotosAPI<[Photo]>(data: photos(), apiError: nil)
        let photosEndPoints = PhotosEndPoints(scheme: "http", host: "host")
        let photosViewModel = PhotosViewModel(photosView: mockView, photosApi: mockPhotosApi, imagesEndpoints: photosEndPoints)
        
        MockPhotoLibraryPermission.setStatus(.denied, grantedWhenAsked: false)
        
        photosViewModel.choosePhotoFromGallary(with: MockPhotoLibraryPermission.self)
        
        XCTAssertTrue(mockView.isShowALertCalled)
        XCTAssert(mockView.alertTitle == "Permission Required".localised)
        XCTAssert(mockView.alertMessage == "Please go to Setting and provide Photo Library Permission".localised)
    }
    
    private func photos() -> [Photo] {
        let photo1 = Photo(photoId: "photoId1", width: 1, height: 2)
        let photo2 = Photo(photoId: "photoId2", width: 3, height: 4)
        let photo3 = Photo(photoId: "photoId3", width: 5, height: 6)
        let photo4 = Photo(photoId: nil, width: 7, height: 8)
        
        return [photo1, photo2, photo3, photo4]
    }
    
}
