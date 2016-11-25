//
//  JQHomeStatusDAL.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/25.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQHomeStatusDAL: NSObject {

    
    // 1. 检测是否有本地数据
    
    // 2. 有本地缓存 则将数据给viewmodel
    
    // 3. 如果没有本地缓存 则进行网络请求, 然后交给则将数据给viewmodel
    // 在数据库中查找数据
    class func checkCacheStatus() -> [[String : Any]]? {
        
        let sql = "SELECT status FROM T_Status"
        
        var array:[[String : Any]]?
        
        JQSQLiteTools.shared.queue.inDatabase { (db) in
            
            array = [[String : Any]]()
            
            let result = db!.executeQuery(sql, withArgumentsIn: nil)!
            
            while result.next() {
                
                //获取二进制数据
                let jsonData = result.data(forColumn: "status")!
                
                let dict = try! JSONSerialization.jsonObject( with: jsonData, options: []) as! [String : Any]
                
                array?.append(dict)
            }
        }
        
        return array
    }
    
    // 4. 将网络数据存储在本地缓存
    // "'statusId'  status'  userId
    class func cacheStatus(array: [[String : Any]]) {
        
        guard let uid = JQUserAccountViewModel.sharedModel.userAccount?.uid else {
            print("用户未登录")
            return
        }
        
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status, userId) VALUES (?,?,?)"
        
        //插入数据
        JQSQLiteTools.shared.queue.inTransaction { (db, rollBack) in
            
            for status in array {
                
                let statusId = status["id"]!
                
                //数据及字典无法存储, 需要转为二进制数据
                let jsonData = try! JSONSerialization.data(withJSONObject: status, options: [])
                
                let res = db!.executeUpdate(sql, withArgumentsIn: [statusId, jsonData, uid])
                
                if res {
                    print("插入成功")
                }else {
                    print("插入失败")
                    //执行回滚
                    rollBack?.pointee = true
                }
                
            }
        }
    }
}
