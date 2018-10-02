//
//  PhotoPreviewViewController.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {
    
    static func controller(photos: [PhotoViewModel], selectedIndex: Int) -> PhotoPreviewViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "PhotoPreviewViewController")
        
        let photosPreviewController = vc as! PhotoPreviewViewController
        photosPreviewController.photosPreviewViewModel = PhotosPreviewViewModel(view: photosPreviewController,
                                                                                photos: photos,
                                                                                selectedIndex: selectedIndex)
        return photosPreviewController
    }
    
    @IBOutlet weak var photosPreviewCollectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    private var photosPreviewViewModel: PhotosPreviewViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photosPreviewViewModel.syncronizePhotos()
        photosPreviewViewModel.syncronizePageIndicator()
    }
    
    @IBAction func sharePhoto(_ sender: Any) {
        guard let index = currentVisibleIndex(),
            let cell = self.photosPreviewCollectionView.cellForItem(at: IndexPath(item: index, section: 0)),
            let image = (cell as! PhotoPreviewCell).photoImage.image else{
            return
        }
        
        shareImages([image])
    }
    
    
    private func currentVisibleIndex() -> Int? {
        var point = self.photosPreviewCollectionView.contentOffset
        point.x = point.x + self.view.center.x
        let indexPath = self.photosPreviewCollectionView.indexPathForItem(at: point)
        return indexPath?.item
    }
}

extension PhotoPreviewViewController: PhotosPreviewView {
    
    func setSelectedIndicator(index: Int) {
        self.pageIndicator.numberOfPages = photosPreviewViewModel.photos.count
        self.pageIndicator.currentPage = index
    }
    
    func setSelectedPhoto(index: Int) {
        self.photosPreviewCollectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                                      at: [.centeredVertically, .centeredHorizontally],
                                                           animated: false)
    }
}

extension PhotoPreviewViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let index = currentVisibleIndex() {
            photosPreviewViewModel.setSelectedIndex(index: index)
        }
    }
}

extension PhotoPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photosPreviewViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPreviewCell", for: indexPath)
        
        let photoViewModel = photosPreviewViewModel.photos[indexPath.item]
        (cell as? PhotoPreviewCell)?.set(photoViewModel: photoViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
