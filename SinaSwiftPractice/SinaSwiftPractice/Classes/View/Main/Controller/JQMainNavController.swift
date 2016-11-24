
//
//  JQMainNavController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQMainNavController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决跳转控制器后, 导航控制器侧滑手势失效
        self.interactivePopGestureRecognizer?.delegate = self
        
    }
    //此时会引起另一个问题, 就是当你将代理设置为当前控制器后, 根控制器也会有侧滑手势
    //所以需要判断如果是根控制器, 手势就失效
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //根控制器
        if childViewControllers.count == 1 {
            return false
        }
        return true
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
