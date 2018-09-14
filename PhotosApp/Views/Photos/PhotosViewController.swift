//
//  PhotosViewController.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, PhotosView {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var photosViewModel: PhotosViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        photosViewModel = PhotosViewModel(photosView: self)
        photosViewModel.loadPhotos()
    }
}

extension PhotosViewController {
    
    func showPhotos() {
        messageLabel.isHidden = true
        photosCollectionView.reloadData()
    }
    
    func showMessage(message: String) {
        messageLabel.text = message
        messageLabel.isHidden = false
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        let photoViewModel = photosViewModel.photos[indexPath.item]
        (cell as? PhotoCell)?.set(photoViewModel: photoViewModel)
        
        return cell
    }
    
}

extension PhotosViewController {
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        photosCollectionView.collectionViewLayout.invalidateLayout()
    }
}
