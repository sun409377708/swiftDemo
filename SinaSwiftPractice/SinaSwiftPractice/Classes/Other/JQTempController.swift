//
//  JQTempController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/12.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQTempController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationController?.view.backgroundColor = UIColor.white
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imageName: "navigationbar_back_withtext", target: self, action: #selector(popBack))
        
    }
    
//    @objc private func popBack() {
//        
//       _ = navigationController?.popViewController(animated: true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
