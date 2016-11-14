//
//  ProgressView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    init() {
        
        let rect = CGRect(x: 0, y: 0, width: 0, height: 2)
        
        super.init(frame: rect)
        
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        
        self.alpha = 1
        self.frame.size.width = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.frame.size.width = screenSize.width * 0.6
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.size.width = screenSize.width * 0.8
            })
        }
    }
    
    func endAnimation() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.frame.size.width  = screenSize.width
            
        }) { (_) in
            
            self.alpha = 0
        }
    }
    
}
