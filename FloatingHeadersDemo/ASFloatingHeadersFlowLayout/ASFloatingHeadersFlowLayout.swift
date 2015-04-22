//
//  ASFloatingHeadersFlowLayout.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 22.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//

import UIKit

class ASFloatingHeadersFlowLayout: UICollectionViewFlowLayout {
    
    let sectionHeadersAttributes = NSMutableArray()
    let offsets = NSMutableOrderedSet()
    var needsLayoutUpdate:Bool = false
    
    
    // СДЕЛАТЬ НОРМАЛЬНЫЙ ПЕРЕВОРОТ !!!
    var prevWidth:CGFloat! = nil
    
    func isBoundsChanged(newBounds: CGRect) -> Bool{
        if (self.prevWidth != newBounds.size.width){
            println("CHANGED")
            self.prevWidth = newBounds.size.width
            return true
        }
        return false
    }
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        //   println("RECT = \(NSStringFromCGRect(newBounds))")
        if (self.needsLayoutUpdate){
            return true
        }
        
        
        invalidateLayoutWithContext(invalidationContextForBoundsChange(newBounds))
        return super.shouldInvalidateLayoutForBoundsChange(newBounds)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let attrs = super.layoutAttributesForElementsInRect(rect)
        
        if let collectionView = self.collectionView{
            
            return attrs?.map() {
                
                (attribute) -> UICollectionViewLayoutAttributes in
                
                let attr = attribute as! UICollectionViewLayoutAttributes
                
                let elementKind = attr.representedElementKind
                if (elementKind != nil && elementKind == UICollectionElementKindSectionHeader){
                    let newAttr = self.sectionHeadersAttributes[attr.indexPath.section] as! UICollectionViewLayoutAttributes
                    return newAttr
                }
                
                return attr
            }
        }
        
        return attrs
    }
    
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        var attr = super.layoutAttributesForSupplementaryViewOfKind(elementKind,atIndexPath:indexPath)
        if (elementKind == UICollectionElementKindSectionHeader){
            let newAttr = self.sectionHeadersAttributes[indexPath.section] as! UICollectionViewLayoutAttributes
            return newAttr
        }
        return attr
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
    
    
    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        println("invalidationContextForBoundsChange(\(newBounds))")
        
        var context = super.invalidationContextForBoundsChange(newBounds)
        if (isBoundsChanged(newBounds)){
            self.needsLayoutUpdate = true
            return context
        }
        
        if (self.needsLayoutUpdate){
            return context;
        }
        
        // здесь инвалидируем конкретный аттрибут - выставляем его новые значения!,
        let collectionView = self.collectionView!
        
        let offset:CGFloat = newBounds.origin.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
        
        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader,
            atIndexPaths:[NSIndexPath(forItem: 0, inSection:index)])// еще надо инвалидировать последний индекс
        
        let newAttr = self.sectionHeadersAttributes[index] as! UICollectionViewLayoutAttributes
        var frame = newAttr.frame
        frame.origin = CGPointMake(0,offset)
        newAttr.frame = frame
        newAttr.zIndex = 1024
        
        return context
    }
    
    
    override func prepareLayout() {
        super.prepareLayout()
        println("prepareLayout")
        if (self.needsLayoutUpdate){
            self.sectionHeadersAttributes.removeAllObjects()
            self.offsets.removeAllObjects()
            self.needsLayoutUpdate = false
        }
        
        
        let start = CFAbsoluteTimeGetCurrent()
        
        let cv = self.collectionView!
        self.prevWidth = cv.frame.width
        
        //        let offset:CGFloat = cv.contentOffset.y + cv.contentInset.top
        //        let index = indexForOffset(offset)
        
        let numberOfSections = cv.numberOfSections()
        for var section = 0; section < numberOfSections; ++section {
            
            let attr =  super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,atIndexPath:NSIndexPath(forItem: 0, inSection: section))
            self.sectionHeadersAttributes.addObject(attr)
            //
            //            let elementKind = attr.representedElementKind
            //            if (elementKind != nil && elementKind == UICollectionElementKindSectionHeader){
            //                if (attr.indexPath.section == index){
            //                    var frame = attr.frame
            //                    frame.origin = CGPointMake(0,offset)
            //                    attr.frame = frame
            //                    attr.zIndex = 1024
            //                }
            //            }
            
            if (section > 0){
                self.offsets.addObject(attr.frame.origin.y)
            }
        }
        
        // ПОДУМАТЬ -> тут добавить еще пересчет первого видимого!
        
        
        let stop = CFAbsoluteTimeGetCurrent()
        println("init time = \(stop - start) ")
    }
    
}
