//
//  JQBaseTableController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/13.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit

class JQBaseTableController: UITableViewController, JQVisitorViewDelegate {

    var userLogin:Bool = false
    //访客视图
    lazy var visitorView:JQVisitorView = JQVisitorView()
    
    override func loadView() {
        
        if JQUserAccountViewModel.sharedModel.userLogin {
            //已经登陆
            super.loadView()
            
        }else {
            //未登陆
            view = visitorView
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.delegate = self
        
    }
    
    //MARK: - 实现代理方法
    func userWillLogin() {
        print("denglu")
        
        let oauthVC = JQOAuthController()
        
        let nav = UINavigationController(rootViewController: oauthVC)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func userWillRegister() {
        print("zhuce")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
