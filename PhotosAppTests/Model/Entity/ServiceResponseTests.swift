//
//  ServiceResponseTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class ServiceResponseTests: XCTestCase {
    
    func testShouldThrowExceptionForInValidData() {
        let jsonData = "Some Data".data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().decode(Photo.self, from: jsonData)
            XCTFail()
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testShouldConvertJsonToServiceResponseModel() {
        let jsonData = """
            {
                "content": "Content",
                "error": {
                    "message": "Some Message"
                }
            }
        """.data(using: .utf8)!
        
        do {
            let serviceResponse = try JSONDecoder().decode(ServiceResponse<String>.self, from: jsonData)
            XCTAssertNotNil(serviceResponse)
            XCTAssertEqual(serviceResponse.content, "Content")
            XCTAssertEqual(serviceResponse.error?.message, "Some Message")
        } catch {
            XCTFail()
        }
    }
    
}
