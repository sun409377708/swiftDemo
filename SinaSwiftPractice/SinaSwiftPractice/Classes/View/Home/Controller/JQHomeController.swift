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

private let tipLabelMargin:CGFloat = 35

class JQHomeController: JQBaseTableController {
    
    //微博数组
    lazy var homeViewModel: JQHomeViewModel = JQHomeViewModel()
    
    //上拉加载小菊花
    lazy var activtyView: UIActivityIndicatorView = {
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        return activity
    }()
    
    //提示小Label
    lazy var tipLabel:UILabel = {
        
        let l = UILabel(title: "提示", textColor: UIColor.white, fontSize: 14)
        
        l.backgroundColor = UIColor.orange
        l.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: tipLabelMargin)
        l.textAlignment = .center
        l.isHidden = true
        return l
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            
            visitorView.updateInfo(tipText: "苦涩的痛吹通脸胖的感觉, 永远难忘记, 年少的我稀罕一个人在海关", imageName: nil)
            return
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
        
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        //加载数据
        loadData()
        
        //设置tableView
        setTableView()
        
        //添加提示Label
        tipLabel.frame.origin.y = navBarHeight - tipLabelMargin
        self.navigationController?.view.insertSubview(tipLabel, belowSubview:(navigationController?.navigationBar)!)
        
    }
    private func startAnimation(count: Int) {
        
        if tipLabel.isHidden == false {
            return
        }
        
        self.tipLabel.text = count == 0 ? "没有微博数据" : "有\(count)条数据"
        
        let originalY = self.tipLabel.frame.origin.y
        tipLabel.isHidden = false
        
        UIView.animate(withDuration: 2.0, animations: {
            
            self.tipLabel.frame.origin.y = navBarHeight

            self.view.layoutIfNeeded()
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                self.tipLabel.frame.origin.y = originalY

            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
    
    //MARK: - 开始加载数据
    internal func loadData () {
        homeViewModel.loadData(isPullup: activtyView.isAnimating) { (success, count) in
            
            if !success {
                
                SVProgressHUD.showError(withStatus: AppErrorTip)
                return
            }
            
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
            //执行动画 上拉加载时不执行动画
            if !self.activtyView.isAnimating {
                self.startAnimation(count: count)
            }
            self.activtyView.stopAnimating()

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
        
        tableView.tableFooterView = activtyView
        
        refreshControl = UIRefreshControl()
        
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
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
}

extension JQHomeController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 1. 根据"对应"数据获取cell
        let viewModel = self.homeViewModel.viewmodelArray[indexPath.row]
        
        let cellId = getCellId(model: viewModel)
        
        let cell = cellWithId(cellId: cellId)
        
        // 2. 获取最底部控件的最大Y值
        let height = cell.ToolBarHeight(viewmodel: viewModel)
        return height
    }
    
    internal func cellWithId (cellId : String) -> JQStatusCell {
        
        let nibName = cellId == retweetedCellId ? "JQRetweetedStatus" : "JQStatusCell"
        
        return UINib.init(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).last as! JQStatusCell
    }
    
    internal func getCellId(model: JQStatusViewModel) -> String {
        
        if model.status?.retweeted_status == nil {
            return originalCellId
        }
        return retweetedCellId
    }
    
    //cell将要显示
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == homeViewModel.viewmodelArray.count - 2 && activtyView.isAnimating == false {
            print("~~~~~~~~~~~~")
            print("到底了")
            
            activtyView.startAnimating()

            //开始加载数据
            loadData()
            
        }
    }
}
