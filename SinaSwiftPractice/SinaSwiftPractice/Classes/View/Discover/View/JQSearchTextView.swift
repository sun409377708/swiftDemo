//
//  JQSearchTextView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQSearchTextView: UIView {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var layoutConstant: NSLayoutConstraint!
    
    
    class func loadSearchText() -> JQSearchTextView {
        
        return UINib.init(nibName: "SearchTextView", bundle: nil).instantiate(withOwner: nil, options: nil).last as! JQSearchTextView
    }
    
    override func awakeFromNib() {
        
        // 1. 设置view自身大小
        self.bounds.size.width = UIScreen.main.bounds.size.width

        
        // 2. 设置背景色为透明色, 避免button的视图显示白色
        self.backgroundColor = UIColor.clear
        
        // 3. 设置textField背景色
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.lightGray
        
        // 4. 设置左视图
        self.leftview.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)

        textField.leftView = leftview
        textField.leftViewMode = .always
        
        // 5. 设置圆角
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.red.cgColor
    }
    

    @IBAction func textBeginChange(_ sender: UITextField) {
        
        layoutConstant.constant = cancelBtn.bounds.width + 5
        
        UIView.animate(withDuration: 0.5) {
            
            self.layoutIfNeeded()
        }
    }

    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        layoutConstant.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            
            self.layoutIfNeeded()
        }
        
        self.textField.resignFirstResponder()
    }
    
    
    // MARK: - 懒加载控件
    private lazy var leftview: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "searchbar_textfield_search_icon"))
        
        imageView.contentMode = .center
        
        return imageView
        
    }()

}
