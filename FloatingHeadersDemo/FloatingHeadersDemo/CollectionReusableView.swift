//
//  SectionHeader.swift
//  FloatingHeadersDemo
//
//  Created by Andrey Syvrachev on 22.04.15.
//  Copyright (c) 2015 Andrey Syvrachev. All rights reserved.
//

import UIKit


class CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var label: UILabel!
    
//    let labelLeft = UILabel()
//    let labelRight = UILabel()
//    
//    var section: Int? {
//        get {
//            return self.labelLeft.text?.toInt()
//        }
//        set(section){
//            self.labelLeft.text = "Section: \(section!)"
//        }
//    }
//    
//    var right: String? {
//        get {
//            return self.labelRight.text
//        }
//        set(text){
//            self.labelRight.text = text
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.backgroundColor = UIColor(white: 0.15, alpha:0.5)
//        
//        self.addSubview(labelLeft)
//        self.addSubview(labelRight)
//        
//        self.labelLeft.textColor = .whiteColor()
//        self.labelLeft.text = "20 марта"
//        
//        self.labelRight.textColor = .whiteColor()
//        self.labelRight.text = "19:25"
//        self.labelRight.textAlignment = .Right
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.labelLeft.frame = self.bounds
//        self.labelRight.frame = self.bounds
//        
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
