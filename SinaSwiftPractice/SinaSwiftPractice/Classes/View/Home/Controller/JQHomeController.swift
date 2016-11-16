//
//  JQHomeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import YYModel
import SVProgressHUD

private let cellId = "JQStatusCellid"

class JQHomeController: JQBaseTableController {
    
    //微博数组
    lazy var homeViewModel: JQHomeViewModel = JQHomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            
            visitorView.updateInfo(tipText: "苦涩的痛吹通脸胖的感觉, 永远难忘记, 年少的我稀罕一个人在海关", imageName: nil)
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
        //设置tableView
        setTableView()
        
        //加载数据
        homeViewModel.loadData { (success) in
            if !success {
                
                SVProgressHUD.showError(withStatus: AppErrorTip)
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - 设置tableView
    private func setTableView() {
        
        let nib = UINib.init(nibName: "JQStatusCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        tableView.rowHeight = 360
    }
    
    @objc private func push() {
        
        let tempVC = JQTempController()
                
        navigationController?.pushViewController(tempVC, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.homeViewModel.viewmodelArray.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JQStatusCell

        let model = self.homeViewModel.viewmodelArray[indexPath.row]
        
        cell.viewmodel = model
        
        return cell
    }
    



}
