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
            
            print(code)
            
            return false
        }
        
        return true
    }
}
