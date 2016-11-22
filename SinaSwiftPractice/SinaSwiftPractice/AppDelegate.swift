//
//  AppDelegate.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var pictureVC: JQPictureController = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: itemW, height: itemW)
        
        layout.minimumLineSpacing = selectCellMargin
        layout.minimumInteritemSpacing = selectCellMargin
        
        layout.sectionInset = UIEdgeInsets(top: selectCellMargin, left: selectCellMargin, bottom: 0, right: selectCellMargin)
        
        let vc = JQPictureController(collectionViewLayout: layout)
        
        vc.collectionView?.backgroundColor = UIColor.orange
        return vc
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        registerNotification()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainTab = UINavigationController(rootViewController: JQComposeController())
        
//        let mainTab = defaultController()
        
        window?.rootViewController = mainTab
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func defaultController () -> UIViewController {
        
        return JQUserAccountViewModel.sharedModel.userLogin ? JQWelcomeController() : JQTabBarController()
    }
    
    private func registerNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootController), name: NSNotification.Name(AppSwitchRootViewController), object: nil)
    }
    
    @objc private func changeRootController(noty: Notification) {
        
        if noty.object != nil {
            window?.rootViewController = JQTabBarController()
        }else {
            window?.rootViewController = JQWelcomeController()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

