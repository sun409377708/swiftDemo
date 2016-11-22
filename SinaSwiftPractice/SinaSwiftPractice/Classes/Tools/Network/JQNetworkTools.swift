//
//  JQNetworkTools.swift
//  swift网络框架封装
//
//  Created by maoge on 16/11/13.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod {
    case POST
    case GET
}

class JQNetworkTools: AFHTTPSessionManager {
    
    //创建单例对象
    static let sharedTools:JQNetworkTools = {
        
        let tools = JQNetworkTools()
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")

        return tools
    }()
    
    
    //加载网络请求方法
    func request(method: HTTPMethod, urlString: String, parameter: Any?, finished:@escaping (Any?, Error?) -> ()) {
        
        let successClosure = {(tast: URLSessionDataTask, responseObject: Any?) -> () in
            finished(responseObject, nil)
        }
        
        let failClosure = { (tast: URLSessionDataTask?, error: Error) -> () in
            finished(nil, error)
        }
        
        if method == .GET {
            self.get(urlString, parameters: parameter, progress: nil, success: successClosure, failure: failClosure)
            
        }else {
            self.post(urlString, parameters: parameter, progress: nil, success: successClosure, failure: failClosure)

        }
        
    }
    
    //上传
    func upload(method: HTTPMethod, urlString: String, parameter: Any?, datas: [String : Data], finished:@escaping (Any?, Error?) -> ()) {
        
        self.post(urlString, parameters: parameter, constructingBodyWith: { (formeData) in
            
            for (key, value) in datas {
                formeData.appendPart(withFileData: value, name: key, fileName: "123.png", mimeType: "application/octet-stream")
            }
            
        }, progress: nil, success: { (_, response) in
            
            finished(response, nil)
        }, failure: { (_, error) in
            
            finished(nil, error)
        })
    }
}
