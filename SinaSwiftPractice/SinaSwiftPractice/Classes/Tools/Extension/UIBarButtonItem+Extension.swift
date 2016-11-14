//
//  UIBarButtonItem+Extension.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    
    convenience init(title: String = "", imageName: String? = nil, target: Any?, action: Selector) {
     
        let btn = UIButton()
        
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if imageName != nil {
            btn.setImage(UIImage(named: imageName!), for: .normal)
            btn.setImage(UIImage(named: imageName! + "_highlighted"), for: .highlighted)
        }

        btn.sizeToFit()
        
        //添加点击事件
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init()
        //给当前对象添加自定义视图
        customView = btn
        
    }
}
