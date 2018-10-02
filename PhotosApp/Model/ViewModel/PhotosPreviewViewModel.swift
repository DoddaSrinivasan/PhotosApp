//
//  PhotosPreviewViewModel.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 02/10/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Foundation

protocol PhotosPreviewView {
    func setSelectedPhoto(index: Int)
    func setSelectedIndicator(index: Int)
}

class PhotosPreviewViewModel {
    
    private (set) var  view: PhotosPreviewView
    private (set) var  photos: [PhotoViewModel]
    
    private (set) var  selectedIndex: Int {
        didSet {
            syncronizePageIndicator()
        }
    }
    
    init(view: PhotosPreviewView, photos: [PhotoViewModel], selectedIndex: Int) {
        self.view = view
        self.photos = photos
        self.selectedIndex = selectedIndex
    }
    
    func setSelectedIndex(index: Int) {
        self.selectedIndex = index
    }
    
    func syncronizePhotos() {
        view.setSelectedPhoto(index: selectedIndex)
    }
    
    func syncronizePageIndicator() {
        view.setSelectedIndicator(index: selectedIndex)
    }
    
}
