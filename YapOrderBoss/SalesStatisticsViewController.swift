//
//  SalesStatisticsViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/10.
//

import Foundation
import UIKit
import WebKit

class SalesStatisticsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var webBaseView: UIView!

    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = "navigation_title_salesStatistics".localized()
        }
    }
    
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var viewBackButton: UIView!
    
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var imageHomeButton: UIView!
    
    @IBOutlet weak var labelErrorTitle: UILabel! {
        didSet {
            labelErrorTitle.text = "webview_error_title".localized()
        }
    }
    @IBOutlet weak var labelErrorMessage: UILabel! {
        didSet {
            labelErrorMessage.text = "webview_error_message".localized()
        }
    }
    
    var wkWebView: WKWebView!
    var request: NSMutableURLRequest?
    
    var webURL: String = ""
    
    var isLoadingShow = false
    var isBlankShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        let processPool = WKProcessPool()
        let configuration = createWebviewConfiguration(handler: self, processPool: processPool)
        
        self.wkWebView = WKWebView(frame: CGRect.init(
            x: self.view.frame.minX,
            y: self.view.frame.minY,
            width: self.view.frame.width,
            height: self.view.frame.height - 20 - MAIN_TBBAR_HEIGHT
            
        ), configuration: configuration)
        self.wkWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.wkWebView.allowsLinkPreview = false
//        self.wkWebView.allowsBackForwardNavigationGestures = true

        let userAgent = WKWebView().value(forKey: "userAgent")
        self.wkWebView.customUserAgent = userAgent as! String + " CEO_NATIVE_IOS/1.0.0"
        
        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        
        self.webBaseView.addSubview(self.wkWebView)
        self.webBaseView.addSubview(self.progressbar)
        
//        imageHomeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageHome)))
        imageHome.isHidden = true
        imageHomeButton.isHidden = true
        
        imageBack.isHidden = true
        viewBackButton.isHidden = true
        viewBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageBack)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRemoveObserver(_:)), name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReloadSalesStatisticsView(_:)), name: NSNotification.Name("callReloadSalesStatisticsView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPushSales(_:)), name: NSNotification.Name("callPushSales"), object: nil)
        
        labelErrorTitle.isHidden = true
        labelErrorMessage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        initLoadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
        
        self.isBlankShow = false
        let url = URL(string: "about:blank")
        let request = URLRequest(url:url!)
        self.wkWebView.load(request)
    }
    
    @objc func callRemoveObserver(_ notification: Notification) {
        LogPrint("callRemoveObserver - SalesStatisticsViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callReloadSalesStatisticsView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callPushSales"), object: nil)
    }
    
    @objc func touchImageBack(sender: UITapGestureRecognizer) {
        LogPrint("touchImageBack")
        
        if self.wkWebView.canGoBack {
            self.wkWebView.goBack()
        }
    }
    
    @objc func callReloadSalesStatisticsView(_ notification: Notification) {
        LogPrint("callReloadSalesStatisticsView")
        
        initLoadView()
    }
    
    @objc func callPushSales(_ notification: Notification) {
        LogPrint("callPushSales")
        
        var message = ""
        var status = ""
        var popupStatus = ""
        
        if let userInfo = notification.userInfo as? [String: Any] {
            message = userInfo["message"] as? String ?? ""
            status = userInfo["orderStatus"] as? String ?? ""
        }
        
        let bellName = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL_NAME) as? String ?? BELL_NAME_DEFAULT
        if bellName == BELL_NAME_DEFAULT {                //기본음
            popupStatus = "default_"
            
        } else if bellName == BELL_NAME_LIMCHANGJUNG {   //임창정 음성
            popupStatus = "limchangjung_"
        }
        
        if status == TAB_ORDER_STATUS_ORDER {                           //신규주문
            popupStatus = popupStatus + "order"
            
        } else if status == TAB_ORDER_STATUS_RESERVATIONWAITTING {      //예약주문
            popupStatus = popupStatus + "reservation"
            
        } else if status == TAB_ORDER_STATUS_RESERVATIONWAITTING_10 {   //예약주문_10분전
            popupStatus = popupStatus + "reservation_before10"
            
        } else if status == TAB_ORDER_STATUS_ORDERCANCEL {              //주문취소
            popupStatus = "cancel"
        }
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupNotificationViewController") as? PopupNotificationViewController {
            viewController.popupType = "noti"
            viewController.popupStatus = popupStatus
            viewController.popupMessage = message
            viewController.showAnim(vc: self, type: .move, position: .top, parentAddView: self.view) { }
        }
        
    }
    
    @objc func touchImageHome(sender: UITapGestureRecognizer) {
        LogPrint("touchImageHome")
        self.tabBarController?.selectedIndex = 0
        GlobalShareManager.shared().selectTabIndex = 0
    }
    
    func initLoadView() {
        
        self.isLoadingShow = true
        LoadingView.showLoading()
        
        webURL = GlobalShareManager.shared().move_URL
        GlobalShareManager.shared().move_URL = ""
        
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.progressbar.isHidden = true
        
        self.loadWebView()
    }
    
    public func loadWebView() {
        
        var strUrl: String = ""
        
        if webURL.count > 0 {
            strUrl = webURL
        } else {
            strUrl = NetworkManager.shared().getFrontURL() + URL_SALESSTATISTICS
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
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        LogPrint("runJavaScriptAlertPanelWithMessage")
        showJavaScriptAlert(self, message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        LogPrint("runJavaScriptConfirmPanelWithMessage")
        showJavaScriptConfirmAlert(self, message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LogPrint("didStart")
        
        if self.progressbar.isHidden {
            self.progressbar.isHidden = false
        }

        self.progressbar.setProgress(0.4, animated: false)
        
        self.isLoadingShow = true
        LoadingView.showLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        LogPrint("DecidePolicyFor navigationResponse")
        
        self.progressbar.setProgress(0.6, animated: false)
        
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        LogPrint("didCommit")
        
        self.progressbar.setProgress(0.8, animated: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        LogPrint("didFail")
        
        self.progressbar.setProgress(1.0, animated: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.progressbar.isHidden = true
        }
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
        
        let url = URL(string: "about:blank")
        let request = URLRequest(url:url!)
        self.wkWebView.load(request)
        labelErrorTitle.isHidden = false
        labelErrorMessage.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LogPrint("didFinish")
        
        self.progressbar.setProgress(1.0, animated: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.progressbar.isHidden = true
        }
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if self.progressbar.isHidden {
            self.progressbar.isHidden = false
        }
        self.progressbar.setProgress(0.2, animated: false)
        
        let url: URL = navigationAction.request.url!
        let urlScheme = url.scheme ?? ""
        let urlHost = url.host ?? ""
        let urlPath = url.path
        
        LogPrint("scheme : \(urlScheme)")
        LogPrint("host : \(urlHost)")
        LogPrint("path : \(urlPath)")
        LogPrint("absoluteURL : \(url.absoluteString)")
        
        if url.absoluteString == "about:blank" {

            if !self.isBlankShow {
                self.isBlankShow = true
            } else {
                self.isBlankShow = false
                decisionHandler(.cancel)
                return
            }
        } else {
            
            labelErrorTitle.isHidden = true
            labelErrorMessage.isHidden = true
        }
        
        if urlPath == URL_SALESSTATISTICS_SALE {
            self.labelTitle.text = "navigation_title_salesStatistics".localized()
            self.imageBack.isHidden = true
            self.viewBackButton.isHidden = true
            
        } else if urlPath == URL_SALESSTATISTICS_CALC {
            self.labelTitle.text = "navigation_title_salesStatistics".localized()
            self.imageBack.isHidden = true
            self.viewBackButton.isHidden = true
            
        } else if urlPath == URL_SALESSTATISTICS_DISC {
            self.labelTitle.text = "navigation_title_salesStatistics".localized()
            self.imageBack.isHidden = true
            self.viewBackButton.isHidden = true
            
        } else {
            
            self.imageBack.isHidden = false
            self.viewBackButton.isHidden = false
            
            if urlPath == URL_MANAGEMENT_SALES_RECEIPT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_sales_receipt".localized()
                
            } else if urlPath == URL_MANAGEMENT_SALES_DETAIL {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_sales_detail".localized()
                
            }
            
            if url.absoluteString == "about:blank" {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "navigation_title_salesStatistics".localized()
            }
        }
                
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LogPrint("didFailProvisionalNavigation")
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
        
        let url = URL(string: "about:blank")
        let request = URLRequest(url:url!)
        self.wkWebView.load(request)
        
        labelErrorTitle.isHidden = false
        labelErrorMessage.isHidden = false
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
