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
    class func jq_resizeableImageName(imageName: String) -> UIImage {
        
        guard let image = UIImage(named: imageName) else {
            
            return UIImage()
        }
        
        let w = image.size.width * 0.5
        let h = image.size.height * 0.5
        
        let edge = UIEdgeInsetsMake(h, w, h, w)
        
        return image.resizableImage(withCapInsets: edge, resizingMode: .tile)
    }
    
    //返回缩放后的降帧视图
    func jq_scaleToWidth(width: CGFloat) -> UIImage {
        
        if self.size.width < width {
            return self
        }
        
        let height = width / self.size.width * self.size.height;
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //返回缩放后的降帧视图并控制宽高
    func jq_scaleToWidth(width: CGFloat, height: CGFloat) -> UIImage {
        
        let size = self.jq_scaleOriginalImageWidth(imageWidth: width, imageHeight: height)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //返回缩放后原视图
    func jq_scaleOriginalImageWidth(imageWidth: CGFloat, imageHeight: CGFloat) -> CGSize {
        
        let imageSize = self.size
        
        //判断宽度
        var width: CGFloat
        
        if imageSize.width > imageWidth {
            width = imageWidth
        }else {
            width = imageSize.width
        }
        
        //判断高度
        var height = imageSize.height * width / imageSize.width
        
        if height > imageHeight {
            height = imageHeight
            
            width = height * imageSize.width / imageSize.height
        }
        
        return CGSize(width: width, height: height)
    }
    
    //屏幕截图
    class func snapShotCurrent() -> UIImage {
        //截取当前屏幕
        let window = (UIApplication.shared.keyWindow)!
        // 1. 开启位图
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        //绘制
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        
        //提取
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭
        UIGraphicsEndImageContext()
        
        return image!
    }
}


