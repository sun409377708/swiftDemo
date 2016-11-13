

//
//  UIButton+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/13.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String?, textColor: UIColor, fontSize: CGFloat){
        
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
        
    }
}
