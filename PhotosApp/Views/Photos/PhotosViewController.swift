//
//  PhotosViewController.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class PhotosViewController: UIViewController  {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var photosViewModel: PhotosViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        (photosCollectionView.collectionViewLayout as? MozaicLayout)?.setDelegate(delegate: self)
        photosViewModel = PhotosViewModel(photosView: self)
        photosViewModel.loadPhotos()
    }
    
    
}

//MARK: View Methods
extension PhotosViewController: PhotosView {

    func showPhotos() {
        messageLabel.isHidden = true
        photosCollectionView.reloadData()
    }
    
    func showMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.isHidden = false
    }
    
    func showALertTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localised, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickPhotoFromCamera() {
        
    }
    
    func pickPhotoFromGallary() {
        
    }
}

//MARK: CollectionView DataSource
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

//MARK: Mozaic Layout
extension PhotosViewController: MozaicLayoutDelegate {
    
    func heightForItem(in collectionView: UICollectionView?, forItemWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let photoViewModel = photosViewModel.photos[indexPath.item]
        let height = photoViewModel.heightFor(width: Float(forItemWidth))
        return CGFloat(height)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        photosCollectionView.collectionViewLayout.invalidateLayout()
    }
}

//MARK: Photo Source Chooser
extension PhotosViewController {
    
    @IBAction func showPhotoSourceChooser(_ sender: Any) {
        let alert = UIAlertController(title: "Pick Photo from".localised, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallary".localised, style: .default, handler: { [weak self] (_) in
            self?.photosViewModel.choosePhotoFromGallary(with: PHPhotoLibrary.self)
        }))
        alert.addAction(UIAlertAction(title: "Camera".localised, style: .default, handler: { [weak self] (_) in
            self?.photosViewModel.choosePhotoFromCamera(with: AVCaptureDevice.self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localised, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
