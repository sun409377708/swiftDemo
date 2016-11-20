//
//  JQStatusPictureInfo.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQStatusPictureInfo: NSObject {

    //缩略图
    var thumbnail_pic: String? {
        didSet {
            wap_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    var bmiddle_pic: String?
    
    var wap_pic:String?
}
