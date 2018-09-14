//
//  NetworkableImageViewTests.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import XCTest
@testable import PhotosApp

class MockImageDisplayer: ImageDisplayable {
    var identifier: String?
    var image: UIImage?
}

class NetworkableImageViewTests: XCTestCase {
    
    func testShouldSetImageWithNilImageForMalformedUrl() {
        let urlString = "Some bad Url"
        let url = URL(string: urlString)
        let mockCacheableClient = MockCacheableClient(responndWithUrl: nil, data: nil, error: nil)
        let imageDisplayer = MockImageDisplayer()
        imageDisplayer.setImageWithUrl(url: url, cacheableClient: mockCacheableClient)
        
        XCTAssertNil(imageDisplayer.image)
    }
    
    func testShouldSetImageWithNilIfRequestAndResponseUrlAreDifferent() {
        let requestUrl = URL(string: "http://someimage.jpg")
        let respondedUrl = URL(string: "http://someOtherimage.jpg")
        
        let mockCacheableClient = MockCacheableClient(responndWithUrl: respondedUrl, data: nil, error: nil)
        let imageDisplayer = MockImageDisplayer()
        imageDisplayer.setImageWithUrl(url: requestUrl, cacheableClient: mockCacheableClient)
        
        XCTAssertNil(imageDisplayer.image)
    }
    
    func testShouldSetImageWithNilIfdataIsNil() {
        let requestUrl = URL(string: "http://someimage.jpg")
        
        let mockCacheableClient = MockCacheableClient(responndWithUrl: requestUrl, data: nil, error: nil)
        let imageDisplayer = MockImageDisplayer()
        imageDisplayer.setImageWithUrl(url: requestUrl, cacheableClient: mockCacheableClient)
        
        XCTAssertNil(imageDisplayer.image)
    }
    
    func testShouldSetImageWithData() {
        let requestUrl = URL(string: "http://someimage.jpg")
        let data = getImageData()
        let mockCacheableClient = MockCacheableClient(responndWithUrl: requestUrl, data: data, error: nil)
        let imageDisplayer = MockImageDisplayer()
        imageDisplayer.setImageWithUrl(url: requestUrl, cacheableClient: mockCacheableClient)
        
        XCTAssertNotNil(imageDisplayer.image)
    }
    
    func testShouldUseUIImageViewsAccessibilityIdentitierAsIdentifier1() {
        let imageView = UIImageView(image: nil, highlightedImage: nil)
        imageView.identifier = "Some Identifier"
        
        XCTAssert(imageView.accessibilityIdentifier == "Some Identifier")
    }
    
    func testShouldUseUIImageViewsAccessibilityIdentitierAsIdentifier2() {
        let imageView = UIImageView(image: nil, highlightedImage: nil)
        imageView.accessibilityIdentifier = "Some Identifier"
        
        XCTAssert(imageView.identifier == "Some Identifier")
    }
    
    private func getImageData() -> Data? {
        let bundle = Bundle.init(for: NetworkableImageViewTests.self)
        let image = UIImage(named: "SampleImage.png", in: bundle, compatibleWith: nil)
        return UIImagePNGRepresentation(image!)
    }
    
}
