//
//  WebViewController.swift
//  NerdfeedIpadSwift
//
//  Created by Aleksandr Movsesyan on 10/9/14.
//  Copyright (c) 2014 Aleksandr Movsesyan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var url : NSURL?
    
    func setURL(newUrl: NSURL) {
        url = newUrl
        let req = NSURLRequest(URL: url!)
        let webView = view as UIWebView
        webView.loadRequest(req)
    }
    
    override func loadView() {
        var webView = UIWebView()
        webView.scalesPageToFit = true
        view = webView
    }
}
