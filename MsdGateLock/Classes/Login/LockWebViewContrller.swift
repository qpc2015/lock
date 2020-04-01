//
//  LockWebViewContrller.swift
//  MsdGateLock
//
//  Created by ox o on 2017/6/20.
//  Copyright © 2017年 xiaoxiao. All rights reserved.
//

import UIKit
import WebKit

class LockWebViewContrller: UIViewController {
    
    public var urlStr : String?
    
    lazy var webView : WKWebView = {
        let web = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-64))
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: urlStr!)
        let request = NSURLRequest(url: url!)
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
