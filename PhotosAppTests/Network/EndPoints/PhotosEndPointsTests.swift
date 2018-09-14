//
//  PhotosEndPointsTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotosEndPointsTests: XCTestCase {
    
    func testShouldGetPhotosGetEndPoint() {
        let endPoints = PhotosEndPoints(scheme: "http", host: "host")
        let url = endPoints.getPhotosEndPoint()
        
        XCTAssert(url?.absoluteString == "http://host/photos")
    }
    
}
