//
//  MozaicLayout.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 14/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import UIKit

class MozaicLayout: UICollectionViewLayout {
    
    private let minimumItemWidth: CGFloat = 200.0
    private var itemWidth: CGFloat = 0
    private var columns: [Column] = []
    
    private var numberOfColumns: Int = 0 {
        didSet {
            columns = (0..<numberOfColumns).map({ (index) -> Column in
                Column(index: index)
            })
        }
    }
    
    override func prepare() {
        determineColumnsAndWidthOfEachItem()
        self.collectionView?.alwaysBounceHorizontal = false
        
        let numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for index in 0..<numberOfItems {
            let heightOfItem: CGFloat = 50 //This needs to be brought from the delegate
            let currentColumn = columns[index % numberOfColumns]
            currentColumn.addItem(width: itemWidth, height: heightOfItem)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            let width = self.collectionView?.bounds.size.width ?? 0
            let height = columns.map { (column) -> CGFloat in
                return column.columnHeight()
                }.max() ?? 0
            
            return CGSize(width: width, height: height)
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray: [UICollectionViewLayoutAttributes] = []
        let numberOfItems = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        for index in 0..<numberOfItems {
            if let attributes = layoutAttributesForItem(at: IndexPath(item: index, section: 0)),
                    attributes.frame.intersects(rect){
                attributesArray.append(attributes)
            }
        }
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let currentColumn = columns[indexPath.item % numberOfColumns]
        let indexInColumn = indexPath.item/numberOfColumns
        attributes.frame = currentColumn.itemsBounds[indexInColumn]
        return attributes
    }
    
    
    private func determineColumnsAndWidthOfEachItem() {
        let collectionViewWidth = CGFloat(self.collectionView!.bounds.size.width)
        let width = min(minimumItemWidth, collectionViewWidth/2)
        numberOfColumns = Int(collectionViewWidth)/Int(width)
        itemWidth = collectionViewWidth/CGFloat(numberOfColumns)
        
        print("width: \(collectionViewWidth)")
        print("possible Min Width: \(width)")
        print("columns: \(numberOfColumns)")
        print("item Width: \(itemWidth)")
    }
}

fileprivate class Column {
    private let index: Int
    var itemsBounds: [CGRect]
    
    init(index: Int) {
        self.index = index
        self.itemsBounds = []
    }
    
    func addItem(width: CGFloat, height: CGFloat) {
        let x = CGFloat(index)*width
        
        guard let lastItem = itemsBounds.last else {
            let itemToAdd = CGRect(x: x, y:  0, width: width, height: height)
            itemsBounds.append(itemToAdd)
            return
        }
        
        let lastItemY = lastItem.origin.y
        let newItemY = lastItemY + height
        let itemToAdd = CGRect(x: x, y:  newItemY, width: width, height: height)
        itemsBounds.append(itemToAdd)
    }
    
    func columnHeight() -> CGFloat {
        guard let lastItem = itemsBounds.last else {
            return 0
        }
        
        return lastItem.origin.y + lastItem.size.height
    }
}
