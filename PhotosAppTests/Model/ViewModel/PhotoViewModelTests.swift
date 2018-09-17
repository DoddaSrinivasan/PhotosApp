//
//  PhotoViewModelTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 17/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class PhotoViewModelTests: XCTestCase {
    
    func testShouldGetHeightForAGivenWidth() {
        let photoViewModel = PhotoViewModel(photoUrl: nil, aspectRatio: 0.5)
        
        let height = photoViewModel.heightFor(width: 200)
        XCTAssert(height == 100)
    }
    
}
