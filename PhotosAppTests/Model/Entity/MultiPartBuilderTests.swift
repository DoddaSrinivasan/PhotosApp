//
//  MultiPartBuilderTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 17/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class MultiPartBuilderTests: XCTestCase {
    
    func testShouldBuildMultiPartFormData() {
        let builder = MultiPartBuilder(boundary: "Boundary")
        
        let multiPartData = builder.addImage(name: "file", content: "Image Data".data(using: .utf8)!, fileName: "fileName.png").build()
        let dataString = String.init(data: multiPartData!, encoding: .utf8)
        
        XCTAssert(dataString == "--Boundary\r\nContent-Disposition: form-data; name=\"file\"; filename=\"fileName.png\"\r\nContent-Type: image/png\r\n\r\nImage Data\r\n--Boundary--\r\n")
    }
    
}
