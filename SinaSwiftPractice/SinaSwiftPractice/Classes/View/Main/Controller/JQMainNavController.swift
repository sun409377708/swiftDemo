
//
//  JQMainNavController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQMainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //重写系统方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            //设置返回按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imageName: "navigationbar_back_withtext", target: self, action: #selector(back))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func back() {
        self.popViewController(animated: true)
    }

}
