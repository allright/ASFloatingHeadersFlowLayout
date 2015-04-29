//
//  ASFloatingHeadersFlowLayout.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 22.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//

import UIKit

class ASFloatingHeadersFlowLayout: UICollectionViewFlowLayout {
    
    var sectionAttributes:[(header:UICollectionViewLayoutAttributes!,sectionEnd:CGFloat!)] = []
    let offsets = NSMutableOrderedSet()
    var floatingSectionIndex:Int! = nil
    var width:CGFloat! = nil
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
      
        let attrs = super.layoutAttributesForElementsInRect(rect)
        let ret = attrs?.map() {
            
            (attribute) -> UICollectionViewLayoutAttributes in
            
            let attr = attribute as! UICollectionViewLayoutAttributes
            
            if let elementKind = attr.representedElementKind {
                if (elementKind == UICollectionElementKindSectionHeader){
                    return self.sectionAttributes[attr.indexPath.section].header
                }
            }
            
            return attr
        }
        return ret
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        let collectionView = self.collectionView!
        
        let offset:CGFloat = collectionView.contentOffset.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
        
        var section = self.sectionAttributes[index]
        
        let maxOffsetForHeader = section.sectionEnd - section.header.frame.size.height
        let headerResultOffset = min(offset,maxOffsetForHeader)
        
        let headerAttrs = section.header
        headerAttrs.frame = CGRectMake(0, headerResultOffset, headerAttrs.frame.size.width, headerAttrs.frame.size.height)
        headerAttrs.zIndex = 1024
        
        let attrs = self.sectionAttributes[indexPath.section]
        return elementKind == UICollectionElementKindSectionHeader ? attrs.header : self.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
    }
   
    private func testWidthChanged(newWidth:CGFloat!) -> Bool {
        if let width = self.width{
            if (width != newWidth){
                self.width = newWidth
                return true
            }
        }
        self.width = newWidth
        return false
    }
    
    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        var context = super.invalidationContextForBoundsChange(newBounds)
        
        if (self.testWidthChanged(newBounds.size.width)){
            return context
        }

        let collectionView = self.collectionView!
        
        let offset:CGFloat = newBounds.origin.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
      
        var invalidatedIndexPaths = [NSIndexPath(forItem: 0, inSection:index)];
        if let floatingSectionIndex = self.floatingSectionIndex {
            if (self.floatingSectionIndex != index){
                
                // have to restore previous section attributes to default
                self.sectionAttributes[floatingSectionIndex].header = super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,atIndexPath: NSIndexPath(forItem: 0, inSection: floatingSectionIndex))
                
                invalidatedIndexPaths.append(NSIndexPath(forItem: 0, inSection:floatingSectionIndex))
            }
        }
        self.floatingSectionIndex = index
        
        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader,atIndexPaths:invalidatedIndexPaths)
        return context
    }
    
    override func prepareLayout() {
        
        super.prepareLayout()

        self.sectionAttributes.removeAll(keepCapacity: true)
        self.offsets.removeAllObjects()
        
        let collectionView = self.collectionView!
        
        let numberOfSections = collectionView.numberOfSections()
        for var section = 0; section < numberOfSections; ++section {
            
            let indexPath = NSIndexPath(forItem: 0, inSection: section)
            let header =  super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,atIndexPath:indexPath)
            //let footer =  super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter,atIndexPath:indexPath)
            
           // let height = footer.frame.origin.y - header.frame.origin.y
            var sectionEnd = header.frame.origin.y + header.frame.size.height
            let numberOfItemsInSection = collectionView.numberOfItemsInSection(section)
            if (numberOfItemsInSection > 0){
                let lastItemAttrs = super.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: numberOfItemsInSection - 1, inSection: section))
                sectionEnd = lastItemAttrs.frame.origin.y + lastItemAttrs.frame.size.height + self.sectionInset.bottom
            }
            let sectionInfo:(header:UICollectionViewLayoutAttributes!,sectionEnd:CGFloat!) = (header:header,sectionEnd:sectionEnd)
            self.sectionAttributes.append(sectionInfo)
            
            if (section > 0){
                self.offsets.addObject(header.frame.origin.y)
            }
        }
    }
    
   
    private func indexForOffset(offset: CGFloat) -> Int {
        
        let range = NSRange(location:0, length:self.offsets.count)
        return self.offsets.indexOfObject(offset,
            inSortedRange: range,
            options: .InsertionIndex,
            usingComparator: { (section0:AnyObject!, section1:AnyObject!) -> NSComparisonResult in
                let s0:CGFloat = section0 as! CGFloat
                let s1:CGFloat = section1 as! CGFloat
                return s0 < s1 ? .OrderedAscending : .OrderedDescending
        })
    }
}
