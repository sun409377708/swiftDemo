//
//  JQComposeView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/20.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQComposeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    private func setupUI() {
        //截屏
        let imageView = UIImageView(image: UIImage.snapShotCurrent().applyLightEffect())
            
        addSubview(imageView)
    }
}
