//
//  JQStatus.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQStatus: NSObject {
    
    //	微博ID
    // Int看机型  在32位的机型上面 会出错
    var id: Int = 0
    
    var text:String?
    
    ///微博创建时间
    var created_at: String?
    
    ///微博来源
    var source: String?
    
    //用户
    var user: JQUser?
    
    //配图视图的模型数组
    var pic_urls: [JQStatusPictureInfo]?
    
    override var description: String {
        
        return yy_modelDescription()
    }
}
