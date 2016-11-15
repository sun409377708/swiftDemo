//
//  UIColor+Extension.swift
//  生活圈swift
//
//  Created by maoge on 16/8/9.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func hex_colorWithHex(hex: UInt32) ->  UIColor {
        
                let r = (hex & 0xFF0000) >> 16
        
                let g = (hex & 0x00FF00) >> 8
        
                let b = hex & 0x0000FF
        
        return UIColor.hex_colorWithRed(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b))
    }
    
    class func hex_colorWithRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    class func randomColor () -> UIColor {
                
        return self.hex_colorWithRed(red: CGFloat( arc4random_uniform(256)), green: CGFloat( arc4random_uniform(256)), blue: CGFloat( arc4random_uniform(256)))
    }
}
