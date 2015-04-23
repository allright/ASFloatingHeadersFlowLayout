//
//  ASFloatingHeadersFlowLayout.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 22.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//

import UIKit

class ASFloatingHeadersFlowLayout: UICollectionViewFlowLayout {
    
    var sectionHeadersAttributes:Array<UICollectionViewLayoutAttributes!> = []
    let offsets = NSMutableOrderedSet()
    var floatingSectionIndex:Int! = nil
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        let attrs = super.layoutAttributesForElementsInRect(rect)
        
        return attrs?.map() {
            
            (attribute) -> UICollectionViewLayoutAttributes in
            
            let attr = attribute as! UICollectionViewLayoutAttributes
            
            if let elementKind = attr.representedElementKind {
                if (elementKind == UICollectionElementKindSectionHeader){
                    return self.sectionHeadersAttributes[attr.indexPath.section]
                }
            }
            
            return attr
        }
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        if (elementKind == UICollectionElementKindSectionHeader){
            return self.sectionHeadersAttributes[indexPath.section]
        }
        return super.layoutAttributesForSupplementaryViewOfKind(elementKind,atIndexPath:indexPath)
    }
    
    func indexForOffset(offset: CGFloat) -> Int {
        
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
    
    func setFloatingHeaderOffset(offset:CGFloat, forIndex:Int){
        let attrs = self.sectionHeadersAttributes[forIndex]
        attrs.frame = CGRectMake(0, offset, attrs.frame.size.width, attrs.frame.size.height)
        attrs.zIndex = 1024
    }
    
    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
//        println("invalidationContextForBoundsChange(\(newBounds))")
        
        var context = super.invalidationContextForBoundsChange(newBounds)

        // здесь инвалидируем конкретный аттрибут - выставляем его новые значения!,
        let collectionView = self.collectionView!
        
        let offset:CGFloat = newBounds.origin.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
        
        var invalidatedIndexPaths = [NSIndexPath(forItem: 0, inSection:index)];
        
        self.setFloatingHeaderOffset(offset, forIndex: index)
        
        if let floatingSectionIndex = self.floatingSectionIndex {
            if (self.floatingSectionIndex != index){
                invalidatedIndexPaths.append(NSIndexPath(forItem: 0, inSection:floatingSectionIndex))
            }
        }
        self.floatingSectionIndex = index
        
        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader,atIndexPaths:invalidatedIndexPaths)

        return context
    }
    
    
    override func prepareLayout() {
        
        let start = CFAbsoluteTimeGetCurrent()

        
        super.prepareLayout()
        println("prepareLayout")

        self.sectionHeadersAttributes.removeAll(keepCapacity: true)
        self.offsets.removeAllObjects()
        
        let cv = self.collectionView!
        
        let numberOfSections = cv.numberOfSections()
        for var section = 0; section < numberOfSections; ++section {
            
            let attr =  super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,atIndexPath:NSIndexPath(forItem: 0, inSection: section))
            self.sectionHeadersAttributes.append(attr)
            
            if (section > 0){
                self.offsets.addObject(attr.frame.origin.y)
            }
        }
        
        // ПОДУМАТЬ -> тут добавить еще пересчет первого видимого!
        
        
        let stop = CFAbsoluteTimeGetCurrent()
        println("init time = \(stop - start) ")
    }
    
}
