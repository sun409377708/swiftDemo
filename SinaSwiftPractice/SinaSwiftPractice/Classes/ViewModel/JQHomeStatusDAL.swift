//
//  JQHomeStatusDAL.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/25.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQHomeStatusDAL: NSObject {

    class func loadHomeData (since_id: Int64, max_id: Int64, finished:@escaping ([[String : Any]]?) -> ()) {
        // 1. 检测是否有本地数据
        if let result = checkCacheStatus(since_id: since_id, max_id: since_id), result.count > 0 {
            // 2. 有本地缓存 则将数据给viewmodel
            finished(result)
            return
        }
        // 3. 如果没有本地缓存 则进行网络请求, 然后交给则将数据给viewmodel
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        var parameters = ["access_token" :JQUserAccountViewModel.sharedModel.userAccount?.access_token ?? ""]
        
        if since_id > 0 {
            parameters["since_id"] = "\(since_id)"
        }
        if max_id > 0 {
            parameters["max_id"] = "\(max_id)"
        }
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: parameters) { (responseObject, error) in
            
            if error != nil {
                finished(nil)
                return
            }
            
            let dict = responseObject as! [String : Any]
            
            guard let array = dict["statuses"] as? [[String : Any]] else {
                finished(nil)
                return
            }
            
            finished(array)
            
            // 4. 将数据存储到本地
            cacheStatus(array: array)
        }

    }
 
    // 在数据库中查找数据
    class func checkCacheStatus(since_id: Int64, max_id: Int64) -> [[String : Any]]? {
        
        var sql = "SELECT status FROM T_Status WHERE userId = (?) "
        
        //实现分页查找
        if since_id > 0 {
            //向上查找
            sql += "AND statusId > \(since_id) "
        }
        
        if max_id > 0 {
            //向下查找
            sql += "AND statusId < \(max_id) "
        }
        
        //需要一次限制20条, 顺序倒叙
        sql += "ORDER BY statusId DESC LIMIT 100"
        
        print(sql)
        
        guard let uid = JQUserAccountViewModel.sharedModel.userAccount?.uid else {
            print("用户未登录")
            return nil
        }
        
        var array:[[String : Any]]?
        
        JQSQLiteTools.shared.queue.inDatabase { (db) in
            
            array = [[String : Any]]()
            
            let result = db!.executeQuery(sql, withArgumentsIn: [uid])!
            
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
