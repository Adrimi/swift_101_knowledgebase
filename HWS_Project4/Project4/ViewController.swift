//
//  ViewController.swift
//  Project4
//
//  Created by Adrimi on 20/03/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var webSites = ["apple.com",
                    "hackingwithswift.com"]

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // configure bottom spacer and refresh button
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // LET ADD goBack and goForward buttons :)
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        
        // new UI instance
        progressView = UIProgressView(progressViewStyle: .default)
        // set layout size to fill its fully
        progressView.sizeToFit()
        // create new item using custom BarButtonItem
        let progressButton = UIBarButtonItem(customView: progressView)

        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, refresh]
        navigationController?.isToolbarHidden = false
        
        // configure key value observing
        // who the observer is? (self)
        // what property want to observe (progress)
        // which value we want? (new)
        // context value (nil). "If vou provide value that same context value gets sent back to you when your notifivation value is changed
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in webSites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        // TEST CODE, INSERTING BLACKLISTED SITE!
        ac.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPage))
        // TEST CODE
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // attach to bar button tem fo iPAD
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else {return}
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // called when page finished loading
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // this delegate callbaks allows to decide whether to allow navigation to happen or not EVERY TIME SOMETHING HAPPENES
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        // not all URL has hosts !
        if let host = url?.host {
            for website in webSites {
                if host.contains(website) {
                    // allows loading page
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        showSomeUIAlertContoller(title: "Close!", message: "This site is blockn my friend")
    }
    
    func showSomeUIAlertContoller(title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title:"Continue", style: .default, handler: nil))
        present(vc, animated: true)
    }
    
}

