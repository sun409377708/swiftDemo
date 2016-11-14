//
//  JQUserAccount.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/15.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQUserAccount: NSObject {
    
    /// 访问令牌
    var access_token: String?
    /// 生命周期，多少秒之后就accessToken就不能使用了
    var expires_in: Int = 0
    /// 当前用户的id
    var uid: String?
    /// 过期日期
    var expiresDate: Date?
    /// 用户的昵称
    var name: String?
    /// 用户的头像地址
    var profile_image_url: String?
    
    init(dict: [String : Any]) {
        
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
