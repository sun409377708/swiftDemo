//
//  JQMainTabBar.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/11.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQMainTabBar: UITabBar {
    
    var composeClosure: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        addSubview(composeBtn)
        
        composeBtn.addTarget(self, action: #selector(composeBtnDidClick), for: .touchUpInside)
    }
    
    @objc private func composeBtnDidClick() {
        composeClosure?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.bounds.size.width / 5
        let h = self.bounds.size.height
        
        var index:CGFloat = 0
        for subView in self.subviews {
            if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
               
                subView.frame = CGRect(x: index * w, y: 0, width: w, height: h)
                
                index += 1
                if index == 2 {
                    index += 1
                }
            }
            
        }
        
        //设置button在最中间
        composeBtn.bounds.size = CGSize(width: w, height: h)
        composeBtn.center = CGPoint(x: self.center.x, y: self.bounds.height * 0.5)
        
    }
    
    //实例化中间按钮
    private lazy var composeBtn:UIButton = {
        
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
//        btn.sizeToFit()
        
        return btn
    }()

}
