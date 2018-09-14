//
//  PhotoCell.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func set(photoViewModel: PhotoViewModel) {
        photoImage.setImageWithUrl(url: photoViewModel.photoUrl)
    }
    
}
