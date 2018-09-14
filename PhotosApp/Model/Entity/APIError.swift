//
//  Error.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

struct APIError {
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

extension APIError: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if values.contains(.message) {
            message = try values.decode(String?.self, forKey: .message)
        }
    }
}
