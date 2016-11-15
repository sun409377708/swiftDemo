//
//  NSString+Extension.swift
//  Tools
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit


extension NSString {
    
    //MARK: - 获取路径
    
    //拼接document路径
    func jq_appendDocumentDir() -> String {
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
        
        let result = dir.appendingPathComponent(self.lastPathComponent)
        
        return result
    }
    
    //拼接Cache
    func jq_appendCacheDir() -> String {
        
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString
        
        let result = dir.appendingPathComponent(self.lastPathComponent)
        
        return result
    }
    
    //拼接temp临时文件
    func jq_appendTempDir() -> String {
        
        let dir = NSTemporaryDirectory() as NSString
        
        let result = dir.appendingPathComponent(self.lastPathComponent)
        
        return result
    }
    
    //MARK: - 散列函数MD5
        func md5() -> String {
            let str = self.cString(using: String.Encoding.utf8.rawValue)
            let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8.rawValue))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
            CC_MD5(str!, strLen, result)
            let hash = NSMutableString()
            for i in 0 ..< digestLen {
                hash.appendFormat("%02x", result[i])
            }
            result.deinitialize()
            
            return String(format: hash as String)
        }
    
    //MARK: - Base64
    // Base64加密
    func jq_base64Encode() -> String {
        
        let data = self.data(using: String.Encoding.utf8.rawValue)
    
        guard let newData = data else {
            return ""
        }
        return newData.base64EncodedString(options: .lineLength64Characters)
    }
    
    // Base64解密
    func jq_base64Decode() -> String {
        
        let data = Data(base64Encoded: self as String, options: [])
        
        guard let newData = data else {
            return ""
        }
        
        let str = String(data: newData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        return str ?? ""
    }
}
