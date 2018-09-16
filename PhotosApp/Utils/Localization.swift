//
//  Localization.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 16/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

extension String {
    var localised: String {
        get {
            return NSLocalizedString(self, comment: self)
        }
    }
}
