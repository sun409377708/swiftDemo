//
//  JQWelcomeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/15.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQWelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iconView.snp.updateConstraints { (update) in
            update.centerY.equalTo(view).offset(-100)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: [], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (success) in
            UIView.animate(withDuration: 0.6, animations: {
                
                self.welcomeLabel.alpha = 1
            }, completion: { (_) in
                print("ok")
            })
        }
    }
    
    private func setupUI() {
    
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 90, height: 90))
            make.centerY.equalTo(view).offset(80)
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
    }
    
    
    //懒加载控件
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        
        iv.image = #imageLiteral(resourceName: "avatar_default_big")
        
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    private lazy var welcomeLabel: UILabel = {
        
        let l = UILabel(title: "欢迎归来", textColor: UIColor.darkGray, fontSize: 16)
        l.alpha = 0
        
        return l
    }()

}
