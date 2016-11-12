//
//  JQSearchView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQSearchView: UIButton {
    
   //定义类方法
    class func loadSearchView() -> JQSearchView {
        
        let v = UINib.init(nibName: "SearchView", bundle: nil).instantiate(withOwner: nil, options: nil).last as! JQSearchView
        
        return v
    }
    
    //视图被激活时
    override func awakeFromNib() {
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.layer.cornerRadius = 17
        self.bounds.size.width = UIScreen.main.bounds.size.width
    }
}
