//
//  NSAttributeString+Extension.swift
//  AliyPaySwift
//
//  Created by maoge on 16/8/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    class func imageTextWithImage(image: UIImage, imageWH: CGFloat, title: String, fontSize: CGFloat, titleColor: UIColor, space: CGFloat) -> NSAttributedString {
        
        //图片富文本
        let attachment = NSTextAttachment()
        
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: imageWH, height: imageWH)
        
        let attImage = NSAttributedString(attachment: attachment)
        
        //文字富文本
        let attText = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName : titleColor, NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])
        
        //空格富文本
        let attSpace = NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: space)])
        
        //添加至可变数组
        let attM = NSMutableAttributedString()
        
        attM.append(attImage)
        attM.append(attSpace)
        attM.append(attText)
        
        return attM
        
    }
}
