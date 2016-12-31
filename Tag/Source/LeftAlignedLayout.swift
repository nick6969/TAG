//
//  LeftAlignedLayout.swift
//  CHLtag
//
//  Created by UDT00016 on 8/16/16.
//  Copyright © 2016 UDT00016. All rights reserved.
//

import UIKit

class LeftAlignedLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach({ attributesCopy.append($0.copy() as! UICollectionViewLayoutAttributes) })
        }
        
        for attributes in attributesCopy {
            if attributes.representedElementKind == nil {
                let indexpath = attributes.indexPath
                if let attr = layoutAttributesForItem(at: indexpath) {
                    attributes.frame = attr.frame
                }
            }
        }
        return attributesCopy
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            let sectionInset = self.evaluatedSectionInsetForItemAtIndex(index: indexPath.section)
            let isFirstItemInSection = indexPath.item == 0
            let layoutWidth = self.collectionView!.frame.width - sectionInset.left - sectionInset.right
            
            if (isFirstItemInSection) {
                currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
                return currentItemAttributes
            }
            
            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            
            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let previousFrameRightPoint = previousFrame.origin.x + previousFrame.width
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect(x:sectionInset.left,
                                               y:currentFrame.origin.y,
                                               width:layoutWidth,
                                               height:currentFrame.size.height)
            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            
            if (isFirstItemInRow) {
                currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset: sectionInset)
                return currentItemAttributes
            }
            
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacingForSectionAtIndex(sectionIndex: indexPath.section)
            currentItemAttributes.frame = frame
            return currentItemAttributes
            
        }
        return nil
    }
    
    func evaluatedMinimumInteritemSpacingForSectionAtIndex(sectionIndex:Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            if delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) {
                return delegate.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
                
            }
        }
        return self.minimumInteritemSpacing
        
    }
    
    func evaluatedSectionInsetForItemAtIndex(index: Int) ->UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            if  delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) {
                return delegate.collectionView!(self.collectionView!, layout: self, insetForSectionAt: index)
            }
        }
        return self.sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrameWithSectionInset(sectionInset:UIEdgeInsets){
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

