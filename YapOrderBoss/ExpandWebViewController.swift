//
//  ExpandWebViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/05/02.
//

import Foundation
import UIKit
import WebKit

class ExpandWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var webBaseView: UIView!
    
    @IBOutlet weak var imageBackButton: UIImageView!
    @IBOutlet weak var imageBackView: UIView!
    
    var wkWebView: WKWebView!
    var request: NSMutableURLRequest?
    
    var webURL: String = ""
    
    var isLoadingShow = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        let processPool = WKProcessPool()
        let configuration = createWebviewConfiguration(handler: self, processPool: processPool)
        
        self.wkWebView = WKWebView(frame: CGRect.init(
            x: self.view.frame.minX,
            y: self.view.frame.minY,
            width: self.view.frame.width,
            height: self.view.frame.height - CGFloat(getHomeBarHeight().height)-10 // - 20 - MAIN_TBBAR_HEIGHT
            
        ), configuration: configuration)
        self.wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.wkWebView.allowsBackForwardNavigationGestures = true
        
        let userAgent = WKWebView().value(forKey: "userAgent")
        self.wkWebView.customUserAgent = userAgent as! String + " CEO_NATIVE_IOS/1.0.0"

        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        
        self.webBaseView.addSubview(self.wkWebView)
        
        imageBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageBack)))
        imageBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageBack)))
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        self.isLoadingShow = true
        LoadingView.showLoading()
        
        self.loadWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func touchImageBack(sender: UITapGestureRecognizer) {
        LogPrint("touchImageBack")
        
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false)
    }
    
    public func loadWebView() {
        
        var strUrl: String = ""
        if webURL.count != 0 {
            strUrl = webURL
        } else {
            
        }
        
        let myURL = URL(string: strUrl)
        self.request = nil
        if let anURL = myURL {
            self.request = NSMutableURLRequest(url: anURL)
            let accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
            self.request!.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        self.requestURL(self.request)
    }
    
    func requestURL(_ req: NSMutableURLRequest?) {
        req?.httpShouldHandleCookies = true
        if let aReq = req {
            self.wkWebView.load(aReq as URLRequest)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        LogPrint("contentController : \(message)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        LogPrint("runJavaScriptAlertPanelWithMessage")
        showJavaScriptAlert(self, message, completionHandler: completionHandler)
        
        LogPrint(message)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        LogPrint("runJavaScriptConfirmPanelWithMessage")
        showJavaScriptConfirmAlert(self, message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LogPrint("didStart")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        LogPrint("DecidePolicyFor navigationResponse")
        
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        LogPrint("didCommit")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LogPrint("didFail")
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LogPrint("didFinish")
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url: URL = navigationAction.request.url!
        let urlScheme = url.scheme ?? ""
        let urlHost = url.host ?? ""
        let urlPath = url.path
        
        LogPrint("scheme : \(urlScheme)")
        LogPrint("host : \(urlHost)")
        LogPrint("path : \(urlPath)")
        LogPrint("absoluteURL : \(url.absoluteString)")
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LogPrint("didFailProvisionalNavigation")
        LogPrint(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        LogPrint("didReceive challenge")
        
        // let hostName = webView.url!.host
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        
        if (authenticationMethod == NSURLAuthenticationMethodDefault)
            || (authenticationMethod == NSURLAuthenticationMethodHTTPBasic)
            || (authenticationMethod == NSURLAuthenticationMethodHTTPDigest) {
            
            self.title = "Authentication Challenge"
        }else if (authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            // needs this handling on iOS 9
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        } else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        LogPrint("createWebViewWith")

        if navigationAction.targetFrame == nil  {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
}
