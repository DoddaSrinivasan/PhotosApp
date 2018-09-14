//
//  APIErrorTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class APIErrorTests: XCTestCase {
    
    func testShouldThrowExceptionForInValidData() {
        let jsonData = "Some Data".data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().decode(APIError.self, from: jsonData)
            XCTFail()
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func testShouldConvertJsonToAPIErrorModel() {
        let jsonData = """
            {
                "message": "Error Message"
            }
        """.data(using: .utf8)!
        
        do {
            let apiError = try JSONDecoder().decode(APIError.self, from: jsonData)
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError.message, "Error Message")
        } catch {
            XCTFail()
        }
    }
    
}
