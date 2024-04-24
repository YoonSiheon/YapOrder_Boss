//
//  MoreMenuViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/10.
//

import Foundation
import UIKit
import WebKit
import AVFoundation
import Photos

class MoreMenuViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    var superView: UIViewController!
    
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var webBaseView: UIView!
    
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = "navigation_title_moreMenu".localized()
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
    var saveUrlPath: String = ""
    
    var testDebug: String = "-06"
    
    var isLoadingShow = false
    var isBlankShow = false
    
    var isPermissionCamera = false
    var isPermissionAlbum = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        superView = self
        
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
        
        let userAgent = WKWebView().value(forKey: "userAgent")
        self.wkWebView.customUserAgent = userAgent as! String + " CEO_NATIVE_IOS/1.0.0"
        
        self.wkWebView.uiDelegate = self
        self.wkWebView.navigationDelegate = self
        
        self.webBaseView.addSubview(self.wkWebView)
        
        imageHome.isHidden = true
        imageHomeButton.isHidden = true
        
        imageBack.isHidden = true
        viewBackButton.isHidden = true
        viewBackButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageBack)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRemoveObserver(_:)), name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReloadMoreMenuView(_:)), name: NSNotification.Name("callReloadMoreMenuView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPushMoreMenu(_:)), name: NSNotification.Name("callPushMoreMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callAppUpdate(_:)), name: NSNotification.Name("callAppUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callLogout(_:)), name: NSNotification.Name("callLogout"), object: nil)
        
        labelErrorTitle.isHidden = true
        labelErrorMessage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        checkAlbumPermission()
        checkCameraPermission()
        
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
        LogPrint("callRemoveObserver - MoreMenuViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToForeground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToBackground"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callReloadMoreMenuView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callPushMoreMenu"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callAppUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callLogout"), object: nil)
    }
    
    @objc func appMovedToForeground() {
        LogPrint("appMovedToForeground")
        
        checkAlbumPermission()
        checkCameraPermission()
    }
    
    @objc func appMovedToBackground() {
        LogPrint("appMovedToBackground")
    }
    
    @objc func callReloadMoreMenuView(_ notification: Notification) {
        LogPrint("callReloadMoreMenuView")
        
        initLoadView()
    }
    
    @objc func callPushMoreMenu(_ notification: Notification) {
        LogPrint("callPushMoreMenu")
        
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
    
    @objc func touchImageBack(sender: UITapGestureRecognizer) {
        LogPrint("touchImageBack")
        
        if saveUrlPath == URL_MORE_INFO
            || saveUrlPath == URL_MORE_TIME
            || saveUrlPath == URL_MORE_ORIGIN
            || saveUrlPath == URL_MORE_SALE
            || saveUrlPath == URL_MORE_STAMP
            || saveUrlPath == URL_MORE_NOTI
        {
            webURL = NetworkManager.shared().getFrontURL() + URL_MOREMENU
            self.loadWebView()
            
        } else {
            
            if self.wkWebView.canGoBack {
                self.wkWebView.goBack()
            }
        }
        
    }
    
    @objc func touchImageHome(sender: UITapGestureRecognizer) {
        LogPrint("touchImageHome")
        
        self.tabBarController?.selectedIndex = 0
        GlobalShareManager.shared().selectTabIndex = 0
    }
    
    @objc func callAppUpdate(_ notification: Notification) {
        LogPrint("callAppUpdate")
        
        if let url = URL(string: APPSTORE_URL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {(success) in exit(0)})
        }
    }
    
    @objc func callLogout(_ notification: Notification) {
        LogPrint("callLogout")
        
        let accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        let storeCode = GlobalShareManager.shared().getLocalData(GLOBAL_STORE_CODE) as? String ?? ""
        
        //ysh Logout temp
        let temp = false
        if temp {
            NetworkManager.shared().getLogout(token:accessToken, storeCode:storeCode, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET LOGOUT")
                        
                        let success = data.value(forKey: "success") as? Bool ?? false
                        if success {
                            
                            //로그아웃 데이터 삭제
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_LOGIN_ID)
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_LOGIN_PW)
                            
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_ACCESSTOKEN)
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_STORE_CODE)
                            
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_ALERT)
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_BELL)
                            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_BELL_NAME)
                            
                            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERWAITING
                            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
                            GlobalShareManager.shared().orderTodayArray.removeAll()
                            GlobalShareManager.shared().orderSearchArray.removeAll()
                            
                            GlobalShareManager.shared().homeOrderArray.removeAll()
                            GlobalShareManager.shared().homeLastWeekArray.removeAll()
                            GlobalShareManager.shared().homeThisWeekArray.removeAll()
                            GlobalShareManager.shared().homeLastWeekDailySalesArray.removeAll()
                            GlobalShareManager.shared().homeThisWeekDailySalesArray.removeAll()
                            GlobalShareManager.shared().homeFavoriteArray.removeAll()
                            
                            GlobalShareManager.shared().orderDetailArray.removeAll()
                            GlobalShareManager.shared().orderDiscountArray.removeAll()
                            GlobalShareManager.shared().orderProductArray.removeAll()
                            GlobalShareManager.shared().optionName.removeAll()
                            GlobalShareManager.shared().optionAmount.removeAll()
                            
                            NotificationCenter.default.post(name: NSNotification.Name("callRemoveObserver"), object: nil, userInfo: nil)
                            
                            LogPrint("LOGOUT SUCCESS!!!!")
                            //exit(0)
                            
                            // 로그아웃 성공 후 확인 팝업
                            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                                
                                viewController.modalPresentationStyle = .overFullScreen
                                viewController.popupState = "logout_success"
                                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                            }
                            
                        } else {
                            
                            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                                viewController.popupState = "networkError"
                                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                            }
                        }
                    } else {
                        
                        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                            viewController.popupState = "networkError"
                            viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                        }
                    }
                } else {
                    
                    if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                        viewController.popupState = "networkError"
                        viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                    }
                }
            })
        } else {
            
            //로그아웃 데이터 삭제
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_LOGIN_ID)
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_LOGIN_PW)
            
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_ACCESSTOKEN)
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_STORE_CODE)
            //                        GlobalShareManager.shared().removeLocalData(forKey: FCMTOKEN)
            
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_ALERT)
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_BELL)
            GlobalShareManager.shared().removeLocalData(forKey: GLOBAL_CONFIG_BELL_NAME)
            
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERWAITING
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            GlobalShareManager.shared().orderTodayArray.removeAll()
            GlobalShareManager.shared().orderSearchArray.removeAll()
            
            GlobalShareManager.shared().homeOrderArray.removeAll()
            GlobalShareManager.shared().homeLastWeekArray.removeAll()
            GlobalShareManager.shared().homeThisWeekArray.removeAll()
            GlobalShareManager.shared().homeLastWeekDailySalesArray.removeAll()
            GlobalShareManager.shared().homeThisWeekDailySalesArray.removeAll()
            GlobalShareManager.shared().homeFavoriteArray.removeAll()
            
            GlobalShareManager.shared().orderDetailArray.removeAll()
            GlobalShareManager.shared().orderDiscountArray.removeAll()
            GlobalShareManager.shared().orderProductArray.removeAll()
            GlobalShareManager.shared().optionName.removeAll()
            GlobalShareManager.shared().optionAmount.removeAll()
            
            NotificationCenter.default.post(name: NSNotification.Name("callRemoveObserver"), object: nil, userInfo: nil)
            
            LogPrint("LOGOUT SUCCESS!!!!")
            //exit(0)
            
            // 로그아웃 성공 후 확인 팝업
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                
                viewController.modalPresentationStyle = .overFullScreen
                viewController.popupState = "logout_success"
                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
            }
        }
    }
    
    func initLoadView() {
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.isLoadingShow = true
        LoadingView.showLoading()
        
        webURL = GlobalShareManager.shared().move_URL
        GlobalShareManager.shared().move_URL = ""
        
//        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.progressbar.isHidden = true
        
        self.loadWebView()
    }
  
    public func loadWebView() {
        
        var strUrl: String = ""
        if webURL.count > 0 {
            strUrl = webURL
        } else {
            strUrl = NetworkManager.shared().getFrontURL() + URL_MOREMENU
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
        req?.timeoutInterval = 10
        if let aReq = req {
            self.wkWebView.load(aReq as URLRequest)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        LogPrint("userContentController:\(message.name)")
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
        
        self.isLoadingShow = true
        LoadingView.showLoading()
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
        
        let url = URL(string: "about:blank")
        let request = URLRequest(url:url!)
        self.wkWebView.load(request)
        labelErrorTitle.isHidden = false
        labelErrorMessage.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LogPrint("didFinish")
        
        self.isLoadingShow = false
        LoadingView.hideLoading()
        
        let configAlert = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_ALERT) as? String ?? ""
        let configBell = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL) as? String ?? ""
        let bellName = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL_NAME) as? String ?? ""

        if saveUrlPath == URL_MOREMENU {
            
            //ysh version - test mode
            let appCurrVerString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
//            let appCurrVerString = "1.0.0" + testDebug
            self.wkWebView.evaluateJavaScript("setVersion('\(appCurrVerString)')", completionHandler: { result, error in
                if let inError = error {
                    LogPrint("javascript setVersion error: \(inError.localizedDescription)")
                }
                
                LogPrint("javascript setVersion result: \(result ?? "success")")
            })
        }
        
        if saveUrlPath == URL_MOREMENU || saveUrlPath == URL_MORE_NOTI {
            
            let isAlertUse = (configAlert as NSString).boolValue
            self.wkWebView.evaluateJavaScript("setAlert(\(isAlertUse))", completionHandler: { result, error in
                if let inError = error {
                    LogPrint("javascript setAlert error: \(inError.localizedDescription)")
                }

                LogPrint("javascript setAlert result: \(result ?? "success")")
            })
        }
        
        
        if saveUrlPath == URL_MOREMENU || saveUrlPath == URL_MORE_BELL {
            
            let isBellUse = (configBell as NSString).boolValue
//            let bellList: String = BELL_NAME_DEFAULT + "," + BELL_NAME_LIMCHANGJUNG
            let bellList: String = BELL_NAME_DEFAULT
            self.wkWebView.evaluateJavaScript("setBell(\(isBellUse), '\(bellName)', '\(bellList)')", completionHandler: { result, error in
                if let inError = error {
                    LogPrint("javascript setBell error: \(inError.localizedDescription)")
                }

                LogPrint("javascript setBell result: \(result ?? "success")")
            })
        }
        
        
        //ysh webtitle
//        self.wkWebView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { result, error in
//            LogPrint(result)
//        })
        
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
        
        if urlHost == SCHEMA_LOGOUT {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                viewController.popupCategory = POPUP_STATE_LOGOUT
                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
            }
            
            decisionHandler(.cancel)
            return
            
        } else if urlHost == SCHEMA_SETALERT {
            
            let isUse = (isURLreturnUse(URL: url.absoluteString) as NSString).boolValue
            LogPrint("alert use : \(isUse)")
            GlobalShareManager.shared().setLocalData(dataValue: String(isUse), forKey: GLOBAL_CONFIG_ALERT)
            
            decisionHandler(.cancel)
            return
            
        } else if urlHost == SCHEMA_BELL {
            
            let beforeBellName = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL_NAME) as? String ?? BELL_NAME_DEFAULT
            
            let isUse = (isURLreturnUse(URL: url.absoluteString) as NSString).boolValue
            let bellName = (isURLreturnFilename(URL: url.absoluteString) as NSString) as String
            LogPrint("bell use : \(isUse)")
            
            GlobalShareManager.shared().setLocalData(dataValue: String(isUse), forKey: GLOBAL_CONFIG_BELL)
            GlobalShareManager.shared().setLocalData(dataValue: bellName, forKey: GLOBAL_CONFIG_BELL_NAME)
            
            if beforeBellName != bellName {

                if bellName == BELL_NAME_DEFAULT {

                    soundDefaultOrder()

                } else if bellName == BELL_NAME_LIMCHANGJUNG {

                    soundLimchangjungOrder()
                }
            }
            
            decisionHandler(.cancel)
            return
            
        } else if urlHost == SCHEMA_IMGUPLOAD {

            let target = isURLreturnImgUpload(URL: url.absoluteString)
            LogPrint(target)
            
            let permissionCamera = GlobalShareManager.shared().getLocalData(GLOBAL_PERMISSION_CAMERA) as? String ?? "false"
            let permissionAlbum = GlobalShareManager.shared().getLocalData(GLOBAL_PERMISSION_ALBUM) as? String ?? "false"
            
            if permissionCamera == "false" || permissionAlbum == "false" {

                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                    viewController.popupCategory = POPUP_STATE_PERMISSION_CHECK
                    viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                }

            } else {

                self.wkWebView.evaluateJavaScript("uploadImgReq('\(target)')", completionHandler: { result, error in
                    if let inError = error {
                        LogPrint("javascript uploadImgReq error: \(inError.localizedDescription)")
                        showToast(selfView: self, message: inError.localizedDescription)
                    }

                    LogPrint("javascript uploadImgReq result: \(result ?? "success")")

                })
            }
            
            decisionHandler(.cancel)
            return
        }
        
        if urlPath == URL_SERVICEMANAGEMENT_INFO {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 2
            GlobalShareManager.shared().selectTabIndex = 2
            
        } else if urlPath == URL_SERVICEMANAGEMENT_OPTION {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 2
            GlobalShareManager.shared().selectTabIndex = 2
            
        } else if urlPath == URL_SERVICEMANAGEMENT_OUT {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 2
            GlobalShareManager.shared().selectTabIndex = 2
            
        } else if urlPath == URL_SERVICEMANAGEMENT_ORDER {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 2
            GlobalShareManager.shared().selectTabIndex = 2
            
        } else if urlPath == URL_SALESSTATISTICS_SALE {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 3
            GlobalShareManager.shared().selectTabIndex = 3
            
        } else if urlPath == URL_SALESSTATISTICS_CALC {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 3
            GlobalShareManager.shared().selectTabIndex = 3
            
        } else if urlPath == URL_SALESSTATISTICS_DISC {
            GlobalShareManager.shared().move_URL = url.absoluteString
            self.tabBarController?.selectedIndex = 3
            GlobalShareManager.shared().selectTabIndex = 3
            
        } else if urlPath == URL_MOREMENU {
            self.imageBack.isHidden = true
            self.viewBackButton.isHidden = true
            self.labelTitle.text = "navigation_title_moreMenu".localized()
            
            self.saveUrlPath = urlPath
            
        } else if urlPath == URL_MORE_LOGOUT {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                viewController.popupCategory = POPUP_STATE_LOGOUT
                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
            }
            
        } else {
            
            self.saveUrlPath = urlPath
            
            self.imageBack.isHidden = false
            self.viewBackButton.isHidden = false
            
            if urlPath == URL_MORE_INFO {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "navigation_title_moreMenu".localized()
                
            } else if urlPath == URL_MORE_TIME {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "navigation_title_moreMenu".localized()
                
            } else if urlPath == URL_MORE_ORIGIN {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "navigation_title_moreMenu".localized()
                
            } else if urlPath == URL_MORE_SALE {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_moremenu_marketing_management".localized()
                
            } else if urlPath == URL_MORE_STAMP {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_moremenu_marketing_management".localized()
                
            } else if urlPath == URL_MORE_STORE_EDIT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_store_edit".localized()
                
            } else if urlPath == URL_MORE_STORE_IMAGE_EDIT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_store_image_edit".localized()
                
            } else if urlPath == URL_MORE_STORE_OPENING {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_store_opening_edit".localized()
                
            } else if urlPath == URL_MORE_STORE_HOLIDAY {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_store_holiday_edit".localized()
                
            } else if urlPath == URL_MORE_STORE_ORIGIN_EDIT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_store_origin_edit".localized()
                
            } else if urlPath == URL_MORE_SALE_ADD {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_menu_disc_add".localized()
                
            } else if urlPath == URL_MORE_SALE_EDIT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_menu_disc_edit".localized()
                
            } else if urlPath == URL_MORE_STAMP_ADD {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_stamp_add".localized()
                
            } else if urlPath == URL_MORE_STAMP_EDIT {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_moremenu_stamp_edit".localized()
                
            } else if urlPath == URL_MORE_NOTICE {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_bbs_notice".localized()
                
            } else if urlPath == URL_MORE_FAQ {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_bbs_faq".localized()
                
            } else if urlPath == URL_MORE_NOTI {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_config_noti".localized()
                
            } else if urlPath == URL_MORE_BELL {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_bell".localized()
                
            } else if urlPath == URL_MORE_CKTM {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "view_title_cktm".localized()
                
            } else if urlPath == URL_MORE_MYINFO {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_my_info".localized()
                
            } else if urlPath == URL_MORE_INQUIRY || urlPath == URL_MORE_INQUIRY_ADD {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_inquiry".localized()
                
            } else if urlPath == URL_MORE_TERMS {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "view_title_terms".localized()
                
            } else {
                self.labelTitle.text = SHOW_BACKBUTTON_ADD_TITLE + "navigation_title_moreMenu".localized()
            }
            
            if url.absoluteString == "about:blank" {
                self.imageBack.isHidden = true
                self.viewBackButton.isHidden = true
                self.labelTitle.text = "navigation_title_moreMenu".localized()
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
