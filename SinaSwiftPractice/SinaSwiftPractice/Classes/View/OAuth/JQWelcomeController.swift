//
//  JQWelcomeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/15.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SDWebImage

class JQWelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
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
                //切换控制器
//                UIApplication.shared.keyWindow?.rootViewController = JQTabBarController()
                NotificationCenter.default.post(name: Notification.Name(AppSwitchRootViewController), object: "welcome")
            })
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(white: 235 / 255.0, alpha: 1)
    
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

        iconView.sd_setImage(with: JQUserAccountViewModel.sharedModel.iconURL)
        
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
