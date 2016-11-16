//
//  JQUserAccount.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/15.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQUserAccount: NSObject, NSCoding {
    
    /// 访问令牌
    var access_token: String?
    /// 生命周期，多少秒之后就accessToken就不能使用了
    var expires_in: Int = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    /// 当前用户的id
    var uid: String?
    /// 过期日期
    var expiresDate: Date?
    /// 用户的昵称
    var name: String?
    /// 用户的头像地址
    var avatar_large: String?
    
    init(dict: [String : Any]) {
        
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(expiresDate, forKey: "expiresDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
    }
    
}

extension JQUserAccount {
    
   
    
}
