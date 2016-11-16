//
//  JQUser.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQUser: NSObject {

    // 用户的昵称
    var name: String?
    // 用户的头像
    var avatar_large: String?
    
    /// 认证类型: -1：没有认证，0：认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = 0
    // 会员等级
    var mbrank: Int = 0
}
