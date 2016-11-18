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

private let originalCellId = "JQStatusCellid"
private let retweetedCellId = "JQRetweetedStatusid"

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
        
        let originalNib = UINib.init(nibName: "JQStatusCell", bundle: nil)
        let retweedNib = UINib.init(nibName: "JQRetweetedStatus", bundle: nil)
        
        tableView.register(originalNib, forCellReuseIdentifier: originalCellId)
        tableView.register(retweedNib, forCellReuseIdentifier: retweetedCellId)

        tableView.rowHeight = 360
        
        tableView.separatorStyle = .none
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
        
        let model = self.homeViewModel.viewmodelArray[indexPath.row]

        let cellId = self.getCellId(model: model)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JQStatusCell

        
        cell.viewmodel = model
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 1. 根据"对应"数据获取cell
        let viewModel = self.homeViewModel.viewmodelArray[indexPath.row]
        
        let cellId = getCellId(model: viewModel)
        
        let cell = cellWithId(cellId: cellId)

        // 2. 获取最底部控件的最大Y值
        let height = cell.ToolBarHeight(viewmodel: viewModel)
        return height
    }
    
    private func cellWithId (cellId : String) -> JQStatusCell {
        
        let nibName = cellId == retweetedCellId ? "JQRetweetedStatus" : "JQStatusCell"
        
        return UINib.init(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).last as! JQStatusCell
    }
    
    private func getCellId(model: JQStatusViewModel) -> String {
        
        if model.status?.retweeted_status == nil {
            return originalCellId
        }
        return retweetedCellId
    }
    
    

}
