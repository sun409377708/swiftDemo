//
//  JQComposeView.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/20.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import pop



class JQComposeView: UIView {

    lazy var array:[JQCompose] = {
        
        return self.itemsInfo()
    }()
    
    lazy var menuButton = [JQComposeButton]()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for (i, value) in menuButton.enumerated() {
            animationPop(value: value, index: i, isUp: false)
        }
        
        //延时移除
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.removeFromSuperview()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        for (i, value) in menuButton.enumerated() {
            
            animationPop(value: value, index: i, isUp: true)
        }
        
    }
    
    private func animationPop(value: UIView, index: Int, isUp: Bool) {
        
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        
        //设置属性
        anim?.springSpeed = 10
        anim?.springBounciness = 8
        
        anim?.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        
        //结束位置
        anim?.toValue = NSValue.init(cgPoint: CGPoint(x: value.center.x, y: value.center.y + (isUp ? -350 : 350)))
        
        value.pop_add(anim, forKey: nil)
    }

    
    
    private func setupUI() {
        //截屏
        let imageView = UIImageView(image: UIImage.snapShotCurrent().applyLightEffect())
        
        addSubview(imageView)
        
        //添加按钮
        addButtons()
    }
    
    private func itemsInfo() -> [JQCompose]{
        
        let path = Bundle.main.path(forResource: "compose.plist", ofType: nil)!
        
        let array = NSArray(contentsOfFile: path)!
        
        var tempArr:[JQCompose] = [JQCompose]()
        
        for value in array {
            
            let info = JQCompose(dict: value as! [String : AnyObject])
            
            tempArr.append(info)
        }
        
        return tempArr
    }
    

    private func addButtons() {
        
        let margin = (ScreenWidth - 3 * composeBtnW) / (3 + 1)
        
        let array = itemsInfo()
        
        for (i, value) in array.enumerated() {
            
            let btn = JQComposeButton()
            
            btn.setTitle(value.title, for: .normal)
            btn.setImage(UIImage(named: value.icon!), for: .normal)
            
            let col = i % 3
            let row = i / 3
            
            let btnX = margin + (margin + composeBtnW) * CGFloat(col)
            let btnY = margin + (margin + composeBtnH) * CGFloat(row)
            
            btn.frame = CGRect(x: btnX, y: btnY + ScreenHeight, width: composeBtnW, height: composeBtnH)
            
            btn.tag = i
            
            addSubview(btn)
            
            menuButton.append(btn)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     private func addButtons() {
     
     let margin = (ScreenWidth - 3 * composeBtnW) / (3 + 1)
     
     for i in 0..<6 {
     
     let btn = UIButton()
     
     let att = NSAttributedString.imageTextWithImage(image: #imageLiteral(resourceName: "tabbar_compose_idea"), imageWH: 80, title: "位置", fontSize: 15, titleColor: UIColor.darkGray, space: 7)
     
     btn.setAttributedTitle(att, for: .normal)
     
     btn.backgroundColor = UIColor.red
     btn.titleLabel?.numberOfLines = 0
     btn.titleLabel?.textAlignment = .center
     let col = i % 3
     let row = i / 3
     
     let btnX = margin + (margin + composeBtnW) * CGFloat(col)
     let btnY = margin + (margin + composeBtnH) * CGFloat(row)
     
     btn.frame = CGRect(x: btnX, y: btnY, width: composeBtnW, height: composeBtnH)
     
     addSubview(btn)
     }
     }
     
     */
}
