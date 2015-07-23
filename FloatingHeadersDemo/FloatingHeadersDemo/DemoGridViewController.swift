//
//  ViewController.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 17.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//

import UIKit

let CellReuseId = "Cell"
let HeaderReuseId = "Header"
let FooterReuseId = "Footer"

class DemoGridViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1000
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section%20 + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseId, forIndexPath: indexPath) 
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reuseId = kind == UICollectionElementKindSectionHeader ? HeaderReuseId : FooterReuseId
        let collectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseId, forIndexPath: indexPath) as! CollectionReusableView
        
        collectionReusableView.label.text = "\(reuseId): \(indexPath.section)"
        
        return collectionReusableView
    }
}

