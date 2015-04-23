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
    var previousWidth:CGFloat! = nil
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    func calculateHeaders(){
        self.sectionHeadersAttributes.removeAll(keepCapacity: true)
        self.offsets.removeAllObjects()
        
        let collectionView = self.collectionView!
        
        let numberOfSections = collectionView.numberOfSections()
        for var section = 0; section < numberOfSections; ++section {
            
            let attr =  super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader,atIndexPath:NSIndexPath(forItem: 0, inSection: section))
            self.sectionHeadersAttributes.append(attr)
            
            if (section > 0){
                self.offsets.addObject(attr.frame.origin.y)
            }
        }
        

    }
    
    func setOffsetOfFloatingHeader(){
        let collectionView = self.collectionView!
        let offset:CGFloat = collectionView.contentOffset.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
        self.setFloatingHeaderOffset(offset, forIndex: index)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        println("layoutAttributesForElementsInRect \(rect) ... ")
        println("1contentInset.top = \(self.collectionView!.contentInset.top) .....")
        
        setOffsetOfFloatingHeader()

        let attrs = super.layoutAttributesForElementsInRect(rect)
        
        let ret = attrs?.map() {
            
            (attribute) -> UICollectionViewLayoutAttributes in
            
            let attr = attribute as! UICollectionViewLayoutAttributes
            
            if let elementKind = attr.representedElementKind {
                if (elementKind == UICollectionElementKindSectionHeader){
                    return self.sectionHeadersAttributes[attr.indexPath.section]
                }
            }
            
            return attr
        }
        
        println("layoutAttributesForElementsInRect \(rect) ... OK")
        return ret
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        println("2contentInset.top = \(self.collectionView!.contentInset.top)")

        if (elementKind == UICollectionElementKindSectionHeader){
            setOffsetOfFloatingHeader()
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
        println("SetOffset: \(offset) forIndex:\(forIndex)")
    }
    
//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
//        <#code#>
//    }
    
    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        
        
        var context = super.invalidationContextForBoundsChange(newBounds)
        if let width = self.previousWidth{
            if (width != newBounds.size.width){
                println("FORCE PREPARE LAYOUT width changed \(width) -> \(newBounds.size.width) newBounds = \(newBounds)")
                self.previousWidth = newBounds.size.width
                return context
            }
        }
        
        self.previousWidth = newBounds.size.width

        // здесь инвалидируем конкретный аттрибут - выставляем его новые значения!,
        let collectionView = self.collectionView!
        
        let offset:CGFloat = newBounds.origin.y + collectionView.contentInset.top
        let index = indexForOffset(offset)
  //      self.setFloatingHeaderOffset(offset, forIndex: index)
        

        var invalidatedIndexPaths = [NSIndexPath(forItem: 0, inSection:index)];

        if let floatingSectionIndex = self.floatingSectionIndex {
            if (self.floatingSectionIndex != index){
                invalidatedIndexPaths.append(NSIndexPath(forItem: 0, inSection:floatingSectionIndex))
            }
        }
        self.floatingSectionIndex = index
        
        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader,atIndexPaths:invalidatedIndexPaths)

        println("invalidationContextForBoundsChange(\(newBounds)) \(invalidatedIndexPaths) contentInset.top = \(collectionView.contentInset.top)")

        
        return context
    }
    
    
    override func prepareLayout() {
        
        let start = CFAbsoluteTimeGetCurrent()

        
        super.prepareLayout()
        println("prepareLayout ...")

        calculateHeaders()

        
//        
//        let offset:CGFloat = collectionView.contentOffset.y + collectionView.contentInset.top
//        let index = indexForOffset(offset)
//        self.setFloatingHeaderOffset(offset, forIndex: index)
//        self.floatingSectionIndex = index
        
        // ПОДУМАТЬ -> тут добавить еще пересчет первого видимого!
        
        
        let stop = CFAbsoluteTimeGetCurrent()
        println("prepareLayout ... done in \(stop - start) sec")
    }
    
}
