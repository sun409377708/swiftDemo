//
//  UIImage+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

extension UIImage {

    //UIImage分类, 中心线切图片
    class func resizeableImageName(imageName: String) -> UIImage {
        
        guard let image = UIImage(named: imageName) else {
            
            return UIImage()
        }
        
        let w = image.size.width * 0.5
        let h = image.size.height * 0.5
        
        let edge = UIEdgeInsetsMake(h, w, h, w)
        
        return image.resizableImage(withCapInsets: edge, resizingMode: .tile)
    }
}


