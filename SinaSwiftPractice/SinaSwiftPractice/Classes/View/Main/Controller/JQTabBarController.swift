//
//  JQTabBarController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orange

        var tempArrM = [UIViewController]()
        
        tempArrM.append(self.addControllers(clsName: "JQHomeController", title: "首页", imageName: "tabbar_home"))
        tempArrM.append(self.addControllers(clsName: "JQMessageController", title: "消息", imageName: "tabbar_message_center"))
        tempArrM.append(self.addControllers(clsName: "JQDiscoverController", title: "发现", imageName: "tabbar_discover"))
        tempArrM.append(self.addControllers(clsName: "JQProfileController", title: "我", imageName: "tabbar_profile"))
        
        self.viewControllers = tempArrM
    }
    
    func addControllers(clsName: String, title: String, imageName: String) -> UIViewController {
        
        let cls = NSClassFromString("SinaSwiftPractice." + clsName) as? UIViewController.Type
        
        guard let vc = cls?.init() else {
            return UIViewController()
        }
        
        vc.navigationItem.title = title
        
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        
        //设置偏移
        vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
        let nav = UINavigationController(rootViewController: vc)
        
        return nav
    }

}
