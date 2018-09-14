//
//  PhotosResponse.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

struct ServiceResponse<T: Decodable>: Decodable {
    var content: T?
    var error: APIError?
}
