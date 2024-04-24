//
//  SplashViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    var confirmLocPlc: String = ""
    var splashTime: CGFloat = SPLASH_DELAY_TIME_DEFAULT
    
    @IBOutlet weak var splashCharacterWidth: NSLayoutConstraint!
    @IBOutlet weak var splashCharacterHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        LogPrint("width : \(getScreenSize().width)")
        LogPrint("height : \(getScreenSize().height)")
        
        if getScreenSize().width > 500 && getScreenSize().height > 1000 {
            splashCharacterWidth.constant = splashCharacterWidth.constant * 1.5
            splashCharacterHeight.constant = splashCharacterHeight.constant * 1.5
        }
        
        let savedUUID = GlobalShareManager.shared().getLocalData(DEVICEUUID) as? String ?? ""
        if savedUUID.count == 0 {
            //32 자리 고유번호 UUID
            let deviceUuid = UIDevice.current.identifierForVendor?.uuidString
            let uuid = deviceUuid!.replacingOccurrences(of: "-", with: "")
            GlobalShareManager.shared().setLocalData(dataValue: uuid, forKey: DEVICEUUID)
        }
        
        let configAlert = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_ALERT) as? String ?? ""
        let configBell = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL) as? String ?? ""
        let bellName = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL_NAME) as? String ?? ""
        
        if configAlert.count == 0 {
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_TRUE, forKey: GLOBAL_CONFIG_ALERT)
        }
        
        if configBell.count == 0 {
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_TRUE, forKey: GLOBAL_CONFIG_BELL)
        }
        
        if bellName.count == 0 {
            GlobalShareManager.shared().setLocalData(dataValue: BELL_NAME_DEFAULT, forKey: GLOBAL_CONFIG_BELL_NAME)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callAppUpdate(_:)), name: NSNotification.Name("callAppUpdate"), object: nil)
        
        let savedCameraPermission = GlobalShareManager.shared().getLocalData(CONFIRM_CAMERA_PERMISSION) as? String ?? ""
        if savedCameraPermission.count == 0 {
            if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraPermissionViewController") as? CameraPermissionViewController {
                viewController.modalPresentationStyle = .overFullScreen
                
                DispatchQueue.main.asyncAfter(deadline: .now() + splashTime) {
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
        
        GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_FALSE, forKey: APPUPDATECHECK)
        checkAppVersion()
        
        Timer.scheduledTimer(timeInterval: 0.5,
                             target: self,
                             selector: #selector(self.checkMoveHome),
                             userInfo: nil,
                             repeats: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func checkMoveHome(timer: Timer) {
        
        let savedCameraPermission = GlobalShareManager.shared().getLocalData(CONFIRM_CAMERA_PERMISSION) as? String ?? ""
        let savedFcmToken = GlobalShareManager.shared().getLocalData(FCMTOKEN) as? String ?? ""
        let appUpdateCheck = GlobalShareManager.shared().getLocalData(APPUPDATECHECK) as? String ?? ""
        
        if savedFcmToken.count > 0 && savedCameraPermission.count > 0 && appUpdateCheck == GLOBAL_TRUE {
            
            timer.invalidate()
            
            // 최신버전 -> 메인으로 진입
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.splashTime) {
                let appDelegate: AppDelegate = AppDelegate().sharedInstance()
                appDelegate.moveToLogin()
            }
        }
    }
    
    @objc func callAppUpdate(_ notification: Notification) {
        LogPrint("callAppUpdate")
        
        if let url = URL(string: APPSTORE_URL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {(success) in exit(0)})
        }
    }
    
    func checkAppVersion() {
        
        NetworkManager.shared().getAppVersion(completion: {(success, status, data) in
            if success {
                if (status == 200) {
                    
                    if let appVerData = data.value(forKey: "data") as? NSDictionary {
                    
                        let frcUdtFg = appVerData["frcUdtFg"] as? String ?? "0"
                        let lastestAppVer = appVerData["appVer"] as? String ?? "0.0.0"
                        //let udtMsg = appVerData["udtMsg"] as? String ?? ""
                        let appUrl = appVerData["appUrl"] as? String ?? ""//APPSTORE_URL

                        UserDefaults.standard.set(lastestAppVer, forKey: "lastestAppVer")
                        UserDefaults.standard.set(appUrl, forKey: "appUrl")

                        let appCurrentVersion: Int = getAppVersion().intType
                        let lastestAppVersion: Int = Int(lastestAppVer.replacingOccurrences(of: ".", with: ""))!

                        if lastestAppVer != "0.0.0" {
                            if appCurrentVersion < lastestAppVersion {
                                if frcUdtFg == "1" {
                                    
                                    LogPrint("강제 업데이트 팝업 진행")
                                    
                                    if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {

                                        viewController.modalPresentationStyle = .overFullScreen
                                        viewController.popupState = "appUpdate"
                                        viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                                    }
                                        
                                } else {
                                    
                                    LogPrint("선택 업데이트 팝업 진행") //사장님앱은 나중에 업데이트 불가
                                    
                                    if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {

                                        viewController.modalPresentationStyle = .overFullScreen
                                        viewController.popupState = "appUpdate"
                                        viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                                    }
                                        
                                }
                            } else {
                                
                                GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_TRUE, forKey: APPUPDATECHECK)
                            }
                        }
                    }
                }
            } else {
                LogPrint("[ check app version error : \(data) ]")
                
                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {

                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.popupState = "networkError"
                    viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
                }
                //ysh reload??
            }
        })
        
    }
    
}

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            let color = self.layer.borderColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
}
