//
//  NetworkableImageView.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

protocol ImageDisplayable: class {
    var image: UIImage? { get set }
    var identifier: String? { get set }
}

extension ImageDisplayable {
    func setImageWithUrl(url: URL?, cacheableClient: DownloadProtocol = CacheableClient()) {
        self.image = nil
        self.identifier = url?.absoluteString
        cacheableClient.downloadUrl(url: url) { [weak self] (downloadedUrl, data, error) in
            guard self?.identifier == downloadedUrl?.absoluteString else {
                return
            }
            
            guard let imageData = data else {
                return
            }
            
            self?.image = UIImage(data: imageData)
        }
    }
}

extension UIImageView: ImageDisplayable {
    var identifier: String? {
        get {
            return self.accessibilityIdentifier
        }
        set {
            self.accessibilityIdentifier = newValue
        }
    }
}
