//
//  JQUserAccountViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/15.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

private let path = ("account.plist" as NSString).jq_appendDocumentDir()


class JQUserAccountViewModel: NSObject {
    
    var userAccount:JQUserAccount? {
        didSet {
            let urlString = userAccount?.avatar_large ?? ""
            iconURL = URL(string: urlString)
        }
    }
    
    //用户登录逻辑
    // 1. 首次登陆 -> 账号密码 -> 获取token 
    // 2. 第二次登陆 -> 沙盒读取
    
    var userLogin: Bool {
        
        // 有token 且 token没有过期
        if userAccount?.access_token != nil && isExpires == false{
            return true
        }
        return false
    }
    
    var isExpires: Bool {
        
        //判断是否过期
        if userAccount?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            
            return false
        }
        return true
    }
    
    //头像图片地址
    var iconURL: URL?
    
    override init() {
        super.init()
        
        //读取沙盒的值
        self.userAccount = loadUserAccount()
        
        let urlString = userAccount?.avatar_large ?? ""
        iconURL = URL(string: urlString)
    }
    
    
    //创建单例对象
    static let sharedModel = JQUserAccountViewModel()
    
    //获取token
    func loadAccessToken(code: String, finished:@escaping (Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id" : client_id,
                      "client_secret" : client_secret,
                      "grant_type" : "",
                      "code" : code,
                      "redirect_uri" : redirect_uri]
        
        JQNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameter: params) { (responseObject, error) in
            
            if error != nil {
                
                finished(false)
                return
            }
            
            guard let dict = responseObject as? [String : Any] else {
                finished(false)
                return
            }
            
            self.loadUserInfo(dict: dict, finished: finished)
        }
    }
    
    //加载用户信息
    private func loadUserInfo(dict: [String : Any], finished:@escaping (Bool) -> ()) {
        
        guard let access_token = dict["access_token"], let uid = dict["uid"] else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["access_token" : access_token,
                      "uid" : uid]
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: params) { (responseObject, error) in
            
            if error != nil {
                
                finished(false)
                return
            }
            
            var userInfo = responseObject as! [String : Any]
            
            for keyValues in dict {
                userInfo[keyValues.key] = keyValues.value
            }
            
            //字典转模型
            let account = JQUserAccount(dict : userInfo)
            
            //保存沙盒
            self.saveUserAccount(userAccount: account)
            
            //给userAccount赋值
            self.userAccount = account
            
            finished(true)
            
            print(account)
        }
    }
    
    //归档
    private func saveUserAccount(userAccount : JQUserAccount) {
        
        NSKeyedArchiver.archiveRootObject(userAccount, toFile: path)
        
    }
    
    //解档数据
    private func loadUserAccount() -> JQUserAccount?{
        let account = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? JQUserAccount
        print(path)
        
        return account
    }
}
