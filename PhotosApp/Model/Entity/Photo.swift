//
//  Photo.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

struct Photo {
    var photoId: String?
    var width: Int?
    var height: Int?
    
    enum CodingKeys: String, CodingKey {
        case photoId, width, height
    }
}

extension Photo: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.photoId) {
            photoId = try values.decode(String.self, forKey: .photoId)
        }
        
        if values.contains(.width) {
            width = try values.decode(Int.self, forKey: .width)
        }
        
        if values.contains(.height) {
            height = try values.decode(Int.self, forKey: .height)
        }
    }
}
