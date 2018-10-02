//
//  PhotoPreviewCell.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

class PhotoPreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func set(photoViewModel: PhotoViewModel) {
        photoImage.setImageWithUrl(url: photoViewModel.photoUrl)
    }
    
}
