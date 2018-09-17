//
//  PhotosAPITests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotosAPITests: XCTestCase {
    
    func testShouldGiveGenericErrorOnNetworkError() {
        let mockHttpClient = MockHttpClient(data: nil, error: NSError(domain: "DOMAIN", code: 0, userInfo:nil))
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.handleData(response: nil, error: NSError(domain: "DOMAIN", code: 0, userInfo:nil)) { (photos: [Photo]?, apiError) in
            XCTAssert(apiError?.message == "Something went wrong. Try again later".localised)
        }
    }
    
    func testShouldGiveAPIErrorOnAPIError() {
        let apiError = APIError(message: "Some Error")
        let data = ServiceResponse<[Photo]>(content: nil, error: apiError)
        let mockHttpClient = MockHttpClient(data: data, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.handleData(response: data, error: nil) { (photos: [Photo]?, apiError) in
            XCTAssert(apiError?.message == "Some Error")
        }
    }
    
    func testShouldInvokeHttpClientForPhotosWithProperUrl(){
        let url = PhotosEndPoints().getPhotosEndPoint()
        let mockHttpClient = MockHttpClient(data: nil, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.getPhotos { (photos, error) in
            
        }
        
        XCTAssert(mockHttpClient.url?.absoluteString == url?.absoluteString)
    }
    
    func testShouldInvokeHttpClientForPhotoUploadWithMultiPartData(){
        let url = PhotosEndPoints().getPhotosEndPoint()
        let imageData = "Image Data".data(using: .utf8)!
        let mockHttpClient = MockHttpClient(data: nil, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.uploadPhoto(imageData, name: "SomeImage.png") { (photo, error) in
            
        }
        
        let contentType = mockHttpClient.headers?["Content-Type"]!
        let boundary = contentType?.split(separator: "=").map(String.init)[1]
        let data = MultiPartBuilder(boundary: boundary!).addImage(name: "file", content: imageData, fileName: "SomeImage.png").build()
        
        XCTAssert(mockHttpClient.url?.absoluteString == url?.absoluteString)
        XCTAssert(mockHttpClient.headers?.count == 1)
        XCTAssertNotNil(mockHttpClient.httpBody == data)
    }
    
    func testShouldGivePhotosForGetPhotos() {
        let photo = Photo(photoId: "photoId", width: 100, height: 200)
        let data = ServiceResponse<[Photo]>(content: [photo], error: nil)
        let mockHttpClient = MockHttpClient(data: data, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.getPhotos { (photos, error) in
            XCTAssert(photos?.count == 1)
            XCTAssert(photos?[0].photoId == "photoId")
            XCTAssert(photos?[0].width == 100)
            XCTAssert(photos?[0].height == 200)
        }
    }
    
    func testShouldGivePhotosForUploadedPhoto() {
        let photo = Photo(photoId: "photoId", width: 100, height: 200)
        let data = ServiceResponse<Photo>(content: photo, error: nil)
        let mockHttpClient = MockHttpClient(data: data, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.uploadPhoto(Data(), name: "image.png") { (photo, apiError) in
            XCTAssert(photo?.photoId == "photoId")
            XCTAssert(photo?.width == 100)
            XCTAssert(photo?.height == 200)
        }
    }
    
}
