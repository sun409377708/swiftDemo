
//
//  JQSQLiteTools.swift
//  FMDBSwift
//
//  Created by maoge on 16/11/25.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import FMDB

class JQSQLiteTools: NSObject {

    static let shared = JQSQLiteTools()
    
    let queue : FMDatabaseQueue
    
    override init() {
        
        // 1. 创建并打开数据库
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("my.db")
        
        queue = FMDatabaseQueue(path: path)
        super.init()
        
        // 2. 创建表
        createTable() 
    }
    
    private func createTable() {
        let sql = "CREATE TABLE IF NOT EXISTS 'T_Status' (" +
                "'statusId' INTEGER NOT NULL," +
                "'status' TEXT," +
                "'userId' INTEGER," +
                "PRIMARY KEY('statusId'));"
        
        queue.inDatabase { (db) in
            
            let result = db!.executeStatements(sql)
            
            if result {
                print("表创建成功")
            }else {
                print("表创建失败")
            }
        }
    }
    
}
