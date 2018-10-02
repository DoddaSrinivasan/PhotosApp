//
//  ImagesSharable.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func shareImages(_ images: [UIImage]) {
        let activityItems: [AnyObject] = images
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
