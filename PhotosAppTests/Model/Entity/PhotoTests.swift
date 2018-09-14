//
//  PhotoTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotoTests: XCTestCase {
    
    func testShouldThrowExceptionForInValidData() {
        let jsonData = "Some Data".data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().decode(Photo.self, from: jsonData)
            XCTFail()
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testShouldConvertJsonToPhotoModel() {
        let jsonData = """
            {
                "photoId": "photoId",
                "width": 100,
                "height": 200
            }
        """.data(using: .utf8)!
        
        do {
            let photo = try JSONDecoder().decode(Photo.self, from: jsonData)
            XCTAssertNotNil(photo)
            XCTAssertEqual(photo.photoId, "photoId")
            XCTAssertEqual(photo.width, 100)
            XCTAssertEqual(photo.height, 200)
        } catch {
            XCTFail()
        }
    }
    
}
