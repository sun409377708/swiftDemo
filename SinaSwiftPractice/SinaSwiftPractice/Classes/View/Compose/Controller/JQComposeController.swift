//
//  JQComposeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/21.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SVProgressHUD

enum JQComposeToolBarButtonType {
    case Picture
    case Mention
    case Trend
    case Emoticon
    case Add
}

class JQComposeController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        self.setTextUI()
        self.setNavUI()
        self.setToolBarUI()
        registerNotification()
    }

    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func keyboardWillChange(n: Notification) {
    
        let endFrame = (n.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //改变toolBar的位置
        let offSetY = endFrame.origin.y - ScreenHeight
        
        toolBar.snp.updateConstraints { (update) in
            update.bottom.equalTo(offSetY)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc internal func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func sendBtnClick() {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //2, 参数
        let access_token = JQUserAccountViewModel.sharedModel.userAccount?.access_token ?? ""
        let text = textView.text ?? ""
        
        let params = ["access_token" : access_token, "status" : text]
        
        //发送请求
        JQNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameter: params) { (_, error) in
            
            if error != nil {
                
                SVProgressHUD.showError(withStatus: "发送失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc internal func typeButtonClick(button: UIButton) {
        
        print(button.tag)
        switch button.tag {
        case 0:
            print("发布图片")
        case 1:
            print("发布表情")
        default:
            print("瞎点")
        }
        
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
        
        //设置拖拽回退键盘
        textView.keyboardDismissMode = .onDrag
        textView.alwaysBounceVertical = true
        
        return textView
    }()
    
    internal lazy var placeHolderLabel: UILabel = {
        
        let label = UILabel(title: "分享新鲜事...", textColor: UIColor.lightGray, fontSize: 14)
        return label
    }()
    
    internal lazy var toolBar: UIToolbar = {
        
        let tool = UIToolbar()
        
        var itemArray = [UIBarButtonItem]()
        
        //添加五个按钮
        let imageNames = ["compose_toolbar_picture",
                          "compose_mentionbutton_background",
                          "compose_trendbutton_background",
                          "compose_emoticonbutton_background",
                          "compose_add_background"]
        
        for  (i,value) in imageNames.enumerated() {
            let btn = UIButton()
            btn.setImage(UIImage(named:value), for: .normal)
            btn.setImage(UIImage(named:value + "_highlighted"), for: .highlighted)
            
            btn.tag = i
            btn.sizeToFit()
            btn.addTarget(self, action: #selector(typeButtonClick), for: .touchUpInside)
            
            let item = UIBarButtonItem(customView: btn)
            
            itemArray.append(item)
            
            //添加弹簧
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            itemArray.append(space)
        }
        
        itemArray.removeLast()
        tool.items = itemArray
        
        return tool
    }()

}

extension JQComposeController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        // 1. 设置发送按钮
        self.sendBtn.isEnabled = textView.hasText
        
        // 2. 设置占位文字
        self.placeHolderLabel.isHidden = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.textView.resignFirstResponder()
    }
}

//设置UI相关
extension JQComposeController {
    
    internal func setTextUI() {
        
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
    
    
    internal func setToolBarUI() {
        
        view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
        }
        
    }

}
