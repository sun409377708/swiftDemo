//
//  JQComposeButton.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/21.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

let composeBtnW: CGFloat = 80
let composeBtnH:CGFloat = 110

class JQComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: composeBtnW, width: composeBtnW, height: composeBtnH - composeBtnW)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: composeBtnW, height: composeBtnW)
    }

}
