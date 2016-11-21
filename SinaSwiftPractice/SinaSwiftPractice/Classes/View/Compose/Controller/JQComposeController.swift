//
//  JQComposeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/21.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQComposeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        self.setupUI()
        
//        self.navigationController?.navigationBar.isTranslucent = false
    }

    @objc internal func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func sendBtnClick() {
        
    }
    
    internal lazy var sendBtn: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        
        btn.setTitle("发送", for: .normal)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .disabled)
        
        btn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: btn)
        
        //默认不能交互需设置在barButtonItem上
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    internal lazy var textView:UITextView = {
        
        let textView = UITextView()
        
        textView.backgroundColor = UIColor.brown
        textView.textColor = UIColor.darkGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        
        return textView
    }()
    
    internal lazy var placeHolderLabel: UILabel = {
        
        let label = UILabel(title: "分享新鲜事...", textColor: UIColor.lightGray, fontSize: 14)
        return label
    }()

}

extension JQComposeController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // 1. 设置发送按钮
        self.sendBtn.isEnabled = textView.hasText
        
        // 2. 设置占位文字
        self.placeHolderLabel.isHidden = textView.hasText
    }
}

//设置UI相关
extension JQComposeController {
    
    internal func setupUI() {
        self.setNavUI()
        
        view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(ScreenHeight / 3)
        }
        
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textView).offset(5)
            make.top.equalTo(textView).offset(8)
        }
    }
    
    internal func setNavUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", imageName: nil, target: self, action: #selector(back))
        
        self.navigationItem.rightBarButtonItem = sendBtn
        
        let label = UILabel(title: "", textColor: UIColor.darkGray, fontSize: 16)
        
        var titleText = "发布微博"
        
        label.numberOfLines = 0
        label.textAlignment = .center
        //获取用户名
        if let name = JQUserAccountViewModel.sharedModel.userAccount?.name {
            
            titleText = titleText + "\n" + name
            
            //增加富文本
            let strM = NSMutableAttributedString(string: titleText)
            
            let range = (titleText as NSString).range(of: name)
            
            strM.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.orange], range: range)
            
            label.attributedText = strM
        }else {
            label.text = titleText
        }
        
        label.sizeToFit()
        
        self.navigationItem.titleView = label
    }
    

}
