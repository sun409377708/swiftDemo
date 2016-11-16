//
//  JQHomeViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQHomeViewModel: NSObject {

    //模型数组
    lazy var viewmodelArray: [JQStatusViewModel] = [JQStatusViewModel]()
    
    // MARK: - LOADData
    func loadData(finished: @escaping (Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameter = ["access_token" : JQUserAccountViewModel.sharedModel.userAccount?.access_token ?? ""]
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: parameter) { (responseObject, error) in
            
            if error != nil {
                finished(false)
                return
            }
            
            let dict = responseObject as! [String : Any]
            
            guard let array = dict["statuses"] as? [[String : Any]] else {
                finished(false)
                return
            }
            
            //MVVM模式
            for item in array {
                let viewModel = JQStatusViewModel()
                
                let s = JQStatus()
                
                s.yy_modelSet(with: item)
                
                viewModel.status = s
                
                self.viewmodelArray.append(viewModel)
            }
            
            finished(true)
            
        }
        
    }
}
