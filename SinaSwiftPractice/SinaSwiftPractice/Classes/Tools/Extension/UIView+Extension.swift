//
//  UIView+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

extension UIView {
    
    //为UIView创建分类, 让所有视图都有cornerRadius可视化属性
    @IBInspectable var cornerRadius: CGFloat {
        
        set {
            //设置layer圆角属性
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        
        get {
            return layer.cornerRadius
        }
    }
}
