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
    
    var targetVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //外界调用的方法
    func show(targetVC: UIViewController?) {
        
        self.targetVC = targetVC
        
        targetVC?.view.addSubview(self)
    }
    
    
    //MARK: - 按钮点击
    @objc private func menuButtonClick(button: UIButton) {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            for value in self.menuButton {
                value.alpha = 0.01
                if value == button {
                    value.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                }else {
                    value.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                }
            }
            
        }) { (_) in
            
            let model = self.array[button.tag]
            
            let cls = NSClassFromString(model.className!) as! UIViewController.Type
            
            let vc = cls.init()
            
            let nav = UINavigationController(rootViewController: vc)
            
            self.targetVC?.present(nav, animated: true, completion: { 
                self.removeFromSuperview()
            })
        }
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
        
        addSubview(sloganImage)
        
        sloganImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(100)
        }
        
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
            
            btn.addTarget(self, action: #selector(menuButtonClick), for: .touchUpInside)
            
            addSubview(btn)
            
            menuButton.append(btn)
        }
    }
    
    
    private lazy var sloganImage:UIImageView = UIImageView(image: UIImage(named: "compose_slogan"))

    
    
    
    
    
    
    
    
    
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
