//
//  JQVisitorView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/13.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SnapKit

class JQVisitorView: UIView {

    //定义一个方法, 给外界设置信息
    func updateInfo(tipText: String, imageName: String?) {
        
        tipLabel.text = tipText
        if imageName != nil {
        
            circleView.image = UIImage(named: imageName!)
            iconView.isHidden = true
            backView.isHidden = true
        }else {
            //首页
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = UIColor(white: 0.93, alpha: 1)

        addSubview(circleView)
        addSubview(backView)
        addSubview(iconView)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        circleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-44)
        }
        iconView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        backView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(circleView.snp.bottom).offset(14)
            make.centerX.equalTo(circleView)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(14)
            make.width.equalTo(100)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(14)
            make.width.equalTo(100)
        }
    
        
    }
    
    
    //MARK: - 懒加载控件
    lazy var circleView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    
    lazy var iconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    
    lazy var backView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
    
    //提示文字
    lazy var tipLabel: UILabel = {
        
        let l = UILabel(title: "宁静的夏天, 天空繁星点点,心里头有写思念, 思念着你的脸", textColor: UIColor.darkGray, fontSize: 14)
        l.numberOfLines = 0
        l.preferredMaxLayoutWidth = 224
        return l
    }()
    
    //注册按钮
    lazy var registerBtn: UIButton = {
        
        let btn = UIButton(title: "注册", textColor: UIColor.orange, fontSize: 14)
        //背景
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        
        return btn
    }()
    
    
    //登陆按钮
    lazy var loginBtn: UIButton = {
        
        let btn = UIButton(title: "登陆", textColor: UIColor.darkGray, fontSize: 14)
        //背景
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        
        return btn
    }()
}
