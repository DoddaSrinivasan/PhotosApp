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
    
    func testShouldInvokeHttpClientForPhotosWithProperUrl(){
        let url = PhotosEndPoints().getPhotosEndPoint()
        let mockHttpClient = MockHttpClient(data: nil, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.getPhotos { (photos, error) in
            
        }
        
        XCTAssert(mockHttpClient.url?.absoluteString == url?.absoluteString)
    }
    
    func testShouldGiveGenericErrorOnNetworkError() {
        let mockHttpClient = MockHttpClient(data: nil, error: NSError(domain: "DOMAIN", code: 0, userInfo:nil))
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.getPhotos { (photos, error) in
            XCTAssert(error?.message == "Something went wrong try again later")
        }
    }
    
    func testShouldGiveAPIErrorOnAPIError() {
        let apiError = APIError(message: "Some Error")
        let data = ServiceResponse<[Photo]>(content: nil, error: apiError)
        let mockHttpClient = MockHttpClient(data: data, error: nil)
        
        let photosApi = PhotosAPI(httpClient: mockHttpClient)
        photosApi.getPhotos { (photos, error) in
            XCTAssert(error?.message == "Some Error")
        }
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
    
}
