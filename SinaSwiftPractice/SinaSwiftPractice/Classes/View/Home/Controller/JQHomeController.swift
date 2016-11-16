//
//  JQHomeController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/10.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import YYModel

class JQHomeController: JQBaseTableController {
    
    //微博数组
    lazy var statuses:[JQStatus] = [JQStatus]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            
            visitorView.updateInfo(tipText: "苦涩的痛吹通脸胖的感觉, 永远难忘记, 年少的我稀罕一个人在海关", imageName: nil)
            return
        }
        
        loadData()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
  
    }
    
    @objc private func push() {
        
        let tempVC = JQTempController()
                
        navigationController?.pushViewController(tempVC, animated: true)
    }

    
    // MARK: - LOADData
    private func loadData() {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameter = ["access_token" : JQUserAccountViewModel.sharedModel.userAccount?.access_token ?? ""]
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: parameter) { (responseObject, error) in
            
            if error != nil {
                
                return
            }
            
            let dict = responseObject as! [String : Any]
            
            guard let array = dict["statuses"] as? [[String : Any]] else {
                return
            }
            
            //字典转模型
//            let tempArray = NSArray.yy_modelArray(with: JQStatus.self, json: array)
          
            //MVVM模式
            for item in array {
                
                let s = JQStatus()
                s.yy_modelSet(with: item)
                
                self.statuses.append(s)
            }
            
            //刷新数据
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.statuses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let model = self.statuses[indexPath.row]
        
        cell.textLabel?.text = model.text
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
