

//
//  UILabel+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/13.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit


extension UILabel {
    
    convenience init(title: String?, textColor: UIColor, fontSize: CGFloat){
        
        self.init()
        
        self.text = title
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textAlignment = .center
        
        self.sizeToFit()
        
    }
    
}
