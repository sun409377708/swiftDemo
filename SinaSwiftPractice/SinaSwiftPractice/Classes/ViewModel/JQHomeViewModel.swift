//
//  JQHomeViewModel.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/16.
//  Copyright © 2016年 maoge. All rights reserved.
// 2.00RWLXtBoRkFdE1f247cbce7CGJUAD

import UIKit

class JQHomeViewModel: NSObject {

    //模型数组
    lazy var viewmodelArray: [JQStatusViewModel] = [JQStatusViewModel]()
    
    // MARK: - LOADData
    func loadData(isPullup: Bool, finished: @escaping (Bool, Int) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        var parameter = ["access_token" : JQUserAccountViewModel.sharedModel.userAccount?.access_token ?? ""]
        
        if isPullup {
            //添加参数
            let id = viewmodelArray.last?.status?.id ?? 0 //获取最后一条数据
            parameter["max_id"] = "\(id - 1)"
        }else {
            let id = viewmodelArray.first?.status?.id ?? 0 //获取第一条数据
            parameter["since_id"] = "\(id)"
        }
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: parameter) { (responseObject, error) in
            
            if error != nil {
                finished(false, 0)
                return
            }
            
            let dict = responseObject as! [String : Any]
            
            guard let array = dict["statuses"] as? [[String : Any]] else {
                finished(false, 0)
                return
            }
            
            //MVVM模式
            var tempArrM = [JQStatusViewModel]()
            for item in array {
                let viewModel = JQStatusViewModel()
                
                let s = JQStatus()
                
                s.yy_modelSet(with: item)
                
                viewModel.status = s
            
                self.viewmodelArray.append(viewModel)
                tempArrM.append(viewModel)
            }
            
            
            if isPullup {
                self.viewmodelArray = self.viewmodelArray + tempArrM
            }else {
                self.viewmodelArray = tempArrM + self.viewmodelArray
            }
            
            finished(true, tempArrM.count)
            
        }
        
    }
}
