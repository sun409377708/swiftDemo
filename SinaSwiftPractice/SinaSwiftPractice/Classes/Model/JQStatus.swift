//
//  JQStatus.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import YYModel

class JQStatus: NSObject, YYModel {
    
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
    
    //评论数
    var comments_count: Int = 0
    
    //转发数
    var reposts_count: Int = 0
    
    //点赞数
    var attitudes_count: Int = 0
    
    
    //配图视图的模型数组
    var pic_urls: [JQStatusPictureInfo]?
    
    override var description: String {
        
        return yy_modelDescription()
    }
    
    //实际上是高度发YYModel在转换字典数组的时候 需要将字典转成什么类型的模型对象
    class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pic_urls" : JQStatusPictureInfo.self]
    }
}
