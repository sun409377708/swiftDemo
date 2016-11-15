//
//  JQOAuthController.swift
//  SinaSwiftPractice
//
//  Created by maoge on 16/11/14.
//  Copyright © 2016年 maoge. All rights reserved.
//

import UIKit
import SVProgressHUD

class JQOAuthController: UIViewController {

    lazy var progressView = ProgressView()
    
    lazy var webView: UIWebView = {
        
        let v = UIWebView()
        
        v.delegate = self
        v.isOpaque = false
        
        return v
    }()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoLogin))
        
        view.backgroundColor = UIColor.white
        
        //加载网络
        loadAuthPage()
        
        //添加加载条
        addProgressView()
    }
    
    func addProgressView() {
        
        view.addSubview(progressView)
        
        progressView.frame.origin.y = 64
    }
    
    private func loadAuthPage() {
    
        //https://api.weibo.com/oauth2/authorize?client_id=123050457758183&redirect_uri=http://www.example.com/response&response_type=code
        
        let urlString = "https://api.weibo.com/oauth2/authorize?" + "client_id=" + client_id + "&redirect_uri=" + redirect_uri
        
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)
        
    }
    
    //MARK: - NavgationIt方法
    
    func autoLogin() {
        
        let jsString = "document.getElementById('userId').value = '409377708@qq.com', document.getElementById('passwd').value = 'sunjianqin2'"
            
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
    
    func close()  {
        dismiss(animated: true, completion: nil)
    }
  
}

extension JQOAuthController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        SVProgressHUD.show()
        
        progressView.startAnimation()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        SVProgressHUD.dismiss()
        
        progressView.endAnimation()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("~~~~~~~~~~~~~~~")
        let urlString = request.url?.absoluteString ?? ""
        
        let flag = "code="
        
        if urlString.contains(flag) {
            
            let query = request.url?.query ?? ""
            
            let code = (query as NSString).substring(from: flag.characters.count)
            
            self.loadAccessToken(code: code)
            
            return false
        }
        
        return true
    }
    
    //获取token
    func loadAccessToken(code: String) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id" : client_id,
                      "client_secret" : client_secret,
                      "grant_type" : "",
                      "code" : code,
                      "redirect_uri" : redirect_uri]
        
        JQNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameter: params) { (responseObject, error) in
            
            if error != nil {
                
                return
            }
            
            guard let dict = responseObject as? [String : Any] else {
                return
            }
            
            self.loadUserInfo(dict: dict)
        }
    }
    
    //加载用户信息
    func loadUserInfo(dict: [String : Any]) {
        
        guard let access_token = dict["access_token"], let uid = dict["uid"] else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let params = ["access_token" : access_token,
                      "uid" : uid]
        
        JQNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameter: params) { (responseObject, error) in
            
            if error != nil {
                return
            }
            
            var userInfo = responseObject as! [String : Any]
            
            for keyValues in dict {
                userInfo[keyValues.key] = keyValues.value
            }
            
            //字典转模型
            let account = JQUserAccount(dict : userInfo)
            
            //保存沙盒
            self.saveUserAccount(userAccount: account)
        }
    }
    
    
    
    private func saveUserAccount(userAccount : JQUserAccount) {
        
        let path = ("account.plist" as NSString).jq_appendDocumentDir()
        
        NSKeyedArchiver.archiveRootObject(userAccount, toFile: path)
    }
}
