//
//  LoginViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/25.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfId: UITextField! {
        didSet {
            tfId.placeholder = "login_tf_id_placeholder".localized()
        }
    }
    @IBOutlet weak var tfPw: UITextField! {
        didSet {
            tfPw.placeholder = "login_tf_pw_placeholder".localized()
        }
    }
    @IBOutlet weak var labelAutoLogin: UILabel! {
        didSet {
            labelAutoLogin.text = "login_autologin".localized()
        }
    }
    @IBOutlet weak var labelStoreInquiry: UILabel! {
        didSet {
            labelStoreInquiry.text = "login_storeinquiry".localized()
        }
    }
    @IBOutlet weak var labelSearchPw: UILabel! {
        didSet {
            labelSearchPw.text = "login_searchpw".localized()
        }
    }
    @IBOutlet weak var viewCheckBox: UIView!
    @IBOutlet weak var imgCheckBoxOn: UIImageView!
    @IBOutlet weak var imgCheckBoxOff: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var splashTitle: UIImageView!
    @IBOutlet weak var splashCharacter: UIImageView!
    @IBOutlet weak var splashCharacterWidth: NSLayoutConstraint!
    @IBOutlet weak var splashCharacterHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tfApi: UITextField! {
        didSet {
            tfApi.placeholder = "login_local_api".localized()
        }
    }
    @IBOutlet weak var tfFront: UITextField! {
        didSet {
            tfFront.placeholder = "login_local_front".localized()
        }
    }
    
    
    
    var btnText = "login_button".localized()
    var isCheckBox: Bool = false
    var strId: String = ""
    var strPw: String = ""
    var loginBtnAble: Bool = false
    
    var strAPIUrl = ""
    var strFrontUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashView.isHidden = false
        splashTitle.isHidden = false
        splashCharacter.isHidden = false
        
        if getScreenSize().width > 500 && getScreenSize().height > 1000 {
            splashCharacterWidth.constant = splashCharacterWidth.constant * 1.5
            splashCharacterHeight.constant = splashCharacterHeight.constant * 1.5
        }
        
        tfId.autocorrectionType = .no
        viewCheckBox.isUserInteractionEnabled = true
        labelStoreInquiry.isUserInteractionEnabled = true
        labelSearchPw.isUserInteractionEnabled = true
        viewCheckBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchCheckBox)))
        labelStoreInquiry.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchStoreInquiry)))
        labelSearchPw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchSearchPw)))
        
        tfId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfPw.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if local_server == 0 {
            
            tfApi.isHidden = true
            tfFront.isHidden = true
            
        } else {
            
            tfApi.isHidden = false
            tfFront.isHidden = false
        }
        
        let loginId = GlobalShareManager.shared().getLocalData(GLOBAL_LOGIN_ID) as? String ?? ""
        let loginPw = GlobalShareManager.shared().getLocalData(GLOBAL_LOGIN_PW) as? String ?? ""
        
        if loginId.count == 0 {
            tfId.text = ""
            tfPw.text = ""
            
            loginBtnAble = false
            setLoginButton(btnAble: loginBtnAble)
            
        } else {
            tfId.text = loginId
            tfPw.text = loginPw
            
            loginBtnAble = true
            setLoginButton(btnAble: loginBtnAble)
        }
        
        
        let loginCheckBox = GlobalShareManager.shared().getLocalData(GLOBAL_LOGIN_CHECKBOX) as? String ?? SCHEMA_LOGIN_CHECKBOX_ON
        
        if loginCheckBox == SCHEMA_LOGIN_CHECKBOX_OFF { //checkbox off
            isCheckBox = false
            imgCheckBoxOn.isHidden = true
            imgCheckBoxOff.isHidden = false
            
            splashView.isHidden = true
            splashTitle.isHidden = true
            splashCharacter.isHidden = true
        } else {                                        //checkbox on
            isCheckBox = true
            imgCheckBoxOn.isHidden = false
            imgCheckBoxOff.isHidden = true
            
            actionAutoLogin()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    @IBAction func actionLogin(_ sender: Any) {
        
        let textId = tfId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let textPw = tfPw.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        strId = textId!
        strPw = textPw!
        tfId.endEditing(true)
        tfPw.endEditing(true)
        
        LogPrint("id:\(strId), pw:\(strPw)")
        
        let textApi = tfApi.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let textFront = tfFront.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        GlobalShareManager.shared().globalAPI = "http://" + textApi!
        GlobalShareManager.shared().globalFront = "http://" + textFront!
        
        if textId!.count != 0 && textPw!.count != 0 {
            
            tfApi.isHidden = true
            tfFront.isHidden = true
            
            NetworkManager.shared().getLogin(loginId:strId, loginPw:strPw, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET LOGIN")
                        
                        var companyCode = ""
                        var brandCode = ""
                        var storeCode = ""
                        var userId = ""
                        var userName = ""
                        var accessToken = ""
                        
                        if let completeData = data.value(forKey: "data") as? NSDictionary {
                            
                            companyCode = completeData.value(forKey: "companyCode") as? String ?? ""
                            brandCode = completeData.value(forKey: "brandCode") as? String ?? ""
                            storeCode = completeData.value(forKey: "storeCode") as? String ?? ""
                            userId = completeData.value(forKey: "userId") as? String ?? ""
                            userName = completeData.value(forKey: "userName") as? String ?? ""
                            accessToken = completeData.value(forKey: "accessToken") as? String ?? ""
                            
                            GlobalShareManager.shared().setLocalData(dataValue: companyCode, forKey: GLOBAL_COMPANY_CODE)
                            GlobalShareManager.shared().setLocalData(dataValue: brandCode, forKey: GLOBAL_BRAND_CODE)
                            GlobalShareManager.shared().setLocalData(dataValue: storeCode, forKey: GLOBAL_STORE_CODE)
                            GlobalShareManager.shared().setLocalData(dataValue: userId, forKey: GLOBAL_USER_ID)
                            GlobalShareManager.shared().setLocalData(dataValue: userName, forKey: GLOBAL_USER_NAME)
                            GlobalShareManager.shared().setLocalData(dataValue: accessToken, forKey: GLOBAL_ACCESSTOKEN)
                        }
                        
                        //********************************************************************************************************************//
                        
                        NetworkManager.shared().getPushToken(token: accessToken, storeCode: storeCode, completion: {(success, status, data) in
                            if success {
                                if (status == 200) {
                                    LogPrint("SET PUSHTOKEN SUCCESS")
                                    
                                    if let completeData = data.value(forKey: "data") as? NSDictionary {
                                        let pushId = completeData.value(forKey: "pushId") as? Int64 ?? 0
                                        let posNo = completeData.value(forKey: "posNo") as? String ?? ""
                                        let pushServerType = completeData.value(forKey: "pushServerType") as? String ?? ""
                                        let pushToken = completeData.value(forKey: "pushToken") as? String ?? ""
                                        
                                        GlobalShareManager.shared().setLocalData(dataValue: pushId, forKey: GLOBAL_PUSHID)
                                        GlobalShareManager.shared().setLocalData(dataValue: posNo, forKey: GLOBAL_POSNO)
                                        
                                        //LogPrint("pushId:\(pushId), posNo:\(posNo), pushServerType:\(pushServerType), pushToken:\(pushToken)")
                                    }
                                    
                                    GlobalShareManager.shared().setLocalData(dataValue: self.strId, forKey: GLOBAL_LOGIN_ID)
                                    GlobalShareManager.shared().setLocalData(dataValue: self.strPw, forKey: GLOBAL_LOGIN_PW)
                                    
                                    self.moveToMain()
                                } else if (status == 401) {
                                    LogPrint("code:401, message:UNAUTHORIZED")
                                    showToast(selfView: self, message: "code:401, message:UNAUTHORIZED")
                                    
                                    self.setLoginFrontView(status: "fail")
                                    
                                } else {
                                    LogPrint("SET PUSHTOKEN FAIL")
                                    showToast(selfView: self, message: "SET PUSHTOKEN API FAIL")
                                    
                                    self.setLoginFrontView(status: "fail")
                                }
                            } else {
                                LogPrint("NETWORK FAIL - getPushToken")
                                showToast(selfView: self, message: "NETWORK FAIL - getPushToken")
                                
                                self.setLoginFrontView(status: "fail")
                            }
                        })
                        
                    } else if status == 401 {
                        showToast(selfView: self, message: "login_login_fail".localized())
                        
                        self.setLoginFrontView(status: "fail")
                    } else {
                        LogPrint("SET LOGIN FAIL")
                        
                        showToast(selfView: self, message: "login_login_fail".localized())
                        
                        self.setLoginFrontView(status: "fail")
                    }
                } else {
                    LogPrint("NETWORK FAIL - getLogin")
                    showToast(selfView: self, message: "login_login_fail".localized())
                    
                    self.setLoginFrontView(status: "fail")
                }
            })
            
        } else {
            
            showToast(selfView: self, message: "login_login_fail_empty".localized())
            
            self.setLoginFrontView(status: "fail")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfId.endEditing(true)
        tfPw.endEditing(true)
        
        tfApi.endEditing(true)
        tfFront.endEditing(true)
        
        let textId = tfId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let textPw = tfPw.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textId!.count == 0 {
            strId = ""
        } else {
            strId = textId!
        }
        
        if textPw!.count == 0 {
            strPw = ""
        } else {
            strPw = textPw!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfId.resignFirstResponder()
        tfPw.resignFirstResponder()
        
        tfApi.resignFirstResponder()
        tfFront.resignFirstResponder()
        
        let textId = tfId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let textPw = tfPw.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textId!.count == 0 {
            strId = ""
        } else {
            strId = textId!
        }
        
        if textPw!.count == 0 {
            strPw = ""
        } else {
            strPw = textPw!
        }
        
        return true
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        
        let textId = tfId.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let textPw = tfPw.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textPw!.count != 0 && textId!.count != 0 {
            loginBtnAble = true
            setLoginButton(btnAble: loginBtnAble)
        } else {
            loginBtnAble = false
            setLoginButton(btnAble: loginBtnAble)
        }
    }
    
    @objc func touchCheckBox(sender: UITapGestureRecognizer) {
        LogPrint("touchCheckBox")
        
        isCheckBox = !isCheckBox
        
        if isCheckBox {
            imgCheckBoxOn.isHidden = false
            imgCheckBoxOff.isHidden = true
            
            GlobalShareManager.shared().setLocalData(dataValue: SCHEMA_LOGIN_CHECKBOX_ON, forKey: GLOBAL_LOGIN_CHECKBOX)
        } else {
            imgCheckBoxOn.isHidden = true
            imgCheckBoxOff.isHidden = false
            
            GlobalShareManager.shared().setLocalData(dataValue: SCHEMA_LOGIN_CHECKBOX_OFF, forKey: GLOBAL_LOGIN_CHECKBOX)
        }
    }
    
    @objc func touchStoreInquiry(sender: UITapGestureRecognizer) {
        LogPrint("touchStoreInquiry")
        
        if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpandWebViewController") as? ExpandWebViewController {
            viewController.modalPresentationStyle = .overFullScreen
            viewController.webURL = NetworkManager.shared().getFrontURL() + URL_ENTER
            self.present(viewController, animated: false, completion: nil)
        }
        
    }
    
    @objc func touchSearchPw(sender: UITapGestureRecognizer) {
        LogPrint("touchSearchPw")
        
        if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordChangePopupViewController") as? PasswordChangePopupViewController {
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        LogPrint("keyboardUp")
        
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height/2)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        LogPrint("keyboardDown")
        
        self.view.transform = .identity
    }
    
    func moveToMain() {
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        appDelegate.moveToMain()
    }
    
    func actionAutoLogin() {
        LogPrint("autoLogin ON!!!!!!!!")
        
        if loginBtnAble {
        
            let loginId = GlobalShareManager.shared().getLocalData(GLOBAL_LOGIN_ID) as? String ?? ""
            let loginPw = GlobalShareManager.shared().getLocalData(GLOBAL_LOGIN_PW) as? String ?? ""
        
            if loginId.count != 0 && loginPw.count != 0 {
                
                tfApi.isHidden = true
                tfFront.isHidden = true
                
                NetworkManager.shared().getLogin(loginId:loginId, loginPw:loginPw, completion: {(success, status, data) in
                    if success {
                        if (status == 200) {
                            LogPrint("GET LOGIN")
                            
                            var companyCode = ""
                            var brandCode = ""
                            var storeCode = ""
                            var userId = ""
                            var userName = ""
                            var accessToken = ""
                            
                            if let completeData = data.value(forKey: "data") as? NSDictionary {
                                
                                companyCode = completeData.value(forKey: "companyCode") as? String ?? ""
                                brandCode = completeData.value(forKey: "brandCode") as? String ?? ""
                                storeCode = completeData.value(forKey: "storeCode") as? String ?? ""
                                userId = completeData.value(forKey: "userId") as? String ?? ""
                                userName = completeData.value(forKey: "userName") as? String ?? ""
                                accessToken = completeData.value(forKey: "accessToken") as? String ?? ""
                                
                                GlobalShareManager.shared().setLocalData(dataValue: companyCode, forKey: GLOBAL_COMPANY_CODE)
                                GlobalShareManager.shared().setLocalData(dataValue: brandCode, forKey: GLOBAL_BRAND_CODE)
                                GlobalShareManager.shared().setLocalData(dataValue: storeCode, forKey: GLOBAL_STORE_CODE)
                                GlobalShareManager.shared().setLocalData(dataValue: userId, forKey: GLOBAL_USER_ID)
                                GlobalShareManager.shared().setLocalData(dataValue: userName, forKey: GLOBAL_USER_NAME)
                                GlobalShareManager.shared().setLocalData(dataValue: accessToken, forKey: GLOBAL_ACCESSTOKEN)
                            }
                            
                            //********************************************************************************************************************//
                                
                            NetworkManager.shared().getPushToken(token: accessToken, storeCode: storeCode, completion: {(success, status, data) in
                                if success {
                                    if (status == 200) {
                                        LogPrint("SET PUSHTOKEN SUCCESS")
                                        
                                        if let completeData = data.value(forKey: "data") as? NSDictionary {
                                            let pushId = completeData.value(forKey: "pushId") as? Int64 ?? 0
                                            let posNo = completeData.value(forKey: "posNo") as? String ?? ""
                                            let pushServerType = completeData.value(forKey: "pushServerType") as? String ?? ""
                                            let pushToken = completeData.value(forKey: "pushToken") as? String ?? ""
                                            
                                            GlobalShareManager.shared().setLocalData(dataValue: pushId, forKey: GLOBAL_PUSHID)
                                            GlobalShareManager.shared().setLocalData(dataValue: posNo, forKey: GLOBAL_POSNO)
                                            
                                            //LogPrint("pushId:\(pushId), posNo:\(posNo), pushServerType:\(pushServerType), pushToken:\(pushToken)")
                                        }
                                        
                                        GlobalShareManager.shared().setLocalData(dataValue: loginId, forKey: GLOBAL_LOGIN_ID)
                                        GlobalShareManager.shared().setLocalData(dataValue: loginPw, forKey: GLOBAL_LOGIN_PW)
                                        
                                        self.moveToMain()
                                        
                                    } else if (status == 401) {
                                        LogPrint("code:401, message:UNAUTHORIZED")
                                        showToast(selfView: self, message: "code:401, message:UNAUTHORIZED")
                                        
                                        self.setLoginFrontView(status: "fail")
                                        
                                    } else {
                                        LogPrint("SET PUSHTOKEN FAIL")
                                        showToast(selfView: self, message: "SET PUSHTOKEN FAIL")
                                        
                                        self.setLoginFrontView(status: "fail")
                                    }
                                } else {
                                    LogPrint("NETWORK FAIL - getPushToken")
                                    showToast(selfView: self, message: "NETWORK FAIL - getPushToken")
                                    
                                    self.setLoginFrontView(status: "fail")
                                }
                            })
                            
                        } else if status == 401 {
                            showToast(selfView: self, message: "login_login_fail".localized())
                            
                            self.setLoginFrontView(status: "fail")
                            
                        } else {
                            LogPrint("SET LOGIN FAIL")
                            
                            showToast(selfView: self, message: "login_login_fail".localized())
                            
                            self.setLoginFrontView(status: "fail")
                        }
                    } else {
                        LogPrint("NETWORK FAIL - getLogin")
                        showToast(selfView: self, message: "login_login_fail".localized())
                        
                        self.setLoginFrontView(status: "fail")
                    }
                })
                
            } else {
                showToast(selfView: self, message: "login_login_fail_empty".localized())
                
                self.setLoginFrontView(status: "fail")
            }
            
        } else {
//            showToast(selfView: self, message: "login_login_fail_empty".localized())
            
            self.setLoginFrontView(status: "fail")
        }
    }
    
    func setLoginButton(btnAble: Bool) {

        var config = UIButton.Configuration.filled()
        
        //button 활성화
        if btnAble {
            
            config.baseBackgroundColor = COMMON_ORANGE
            btnLogin.configuration = config
            
            let btnTextAtt = NSMutableAttributedString(string: btnText)
            btnTextAtt.addAttribute(NSAttributedString.Key.foregroundColor, value: COMMON_WHITE, range: NSRange(location: 0, length: btnText.count))
            btnTextAtt.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 1)), range: NSRange(location: 0, length: btnText.count))
            
            btnLogin.setAttributedTitle(btnTextAtt, for: .normal)
            btnLogin.borderColor = COMMON_ORANGE
            
        }
        //button 비활성화
        else {
            config.baseBackgroundColor = COMMON_GRAY2
            btnLogin.configuration = config
            
            let btnTextAtt = NSMutableAttributedString(string: btnText)
            btnTextAtt.addAttribute(NSAttributedString.Key.foregroundColor, value: COMMON_WHITE, range: NSRange(location: 0, length: btnText.count))
            btnTextAtt.addAttribute(.font, value: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 1)), range: NSRange(location: 0, length: btnText.count))
            
            btnLogin.setAttributedTitle(btnTextAtt, for: .normal)
            btnLogin.borderColor = COMMON_GRAY2
        }
        
    }
    
    func setLoginFrontView(status: String) {
        
        if local_server == 0 {
            
            self.tfApi.isHidden = true
            self.tfFront.isHidden = true
            
        } else {
            
            self.tfApi.isHidden = false
            self.tfFront.isHidden = false
        }
        
        if status == "fail" {
            
            self.splashView.isHidden = true
            self.splashTitle.isHidden = true
            self.splashCharacter.isHidden = true
        }
    }
    
}
