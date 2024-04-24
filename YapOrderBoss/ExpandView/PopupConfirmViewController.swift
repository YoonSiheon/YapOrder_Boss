//
//  PopupConfirmViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/11.
//

import UIKit

class PopupConfirmViewController: BasePopupViewController {
    
    @IBOutlet weak var viewPopupView: UIView!
    @IBOutlet weak var labelPopupTitle: UILabel!
    @IBOutlet weak var labelPopupDescription: UILabel!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var labelConfirm: UILabel!
    @IBOutlet weak var viewPopupBg: UIView!
    
    
    @IBOutlet weak var constraintPopupHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintPopupDescriptionHeight: NSLayoutConstraint!
    
    
    var popupState: String = ""
    var popupType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        self.baseViewBack = self.viewPopupBg
        self.baseViewPopup = self.viewPopupView
        self.basePopupType = self.popupType
        
        setViewShadow(view: viewPopupView)
        
        if popupState == "" {
            
        } else if popupState == "networkError" {
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = "popup_networkerror_title".localized()
            labelPopupDescription.text = "popup_networkerror_data_empty".localized()

            labelConfirm.text = "action_confirm".localized()
            
        } else if popupState == "calendarOverDay" {
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = "popup_search_overday_title".localized()
            labelPopupDescription.text = "popup_search_overday".localized()

            labelConfirm.text = "action_confirm".localized()
            
        } else if popupState == "appUpdate" {
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = "popup_update_title".localized()
            labelPopupDescription.text = "popup_update_description".localized()

            labelConfirm.text = "action_confirm".localized()
            
        } else if popupState == "logout_success" {
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.isHidden = true
            labelPopupDescription.text = "popup_logout_success_description".localized()

            labelConfirm.text = "action_confirm".localized()
            
        }
        
        viewConfirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchConfirm)))
        viewPopupBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchPopupBg)))
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
    
    @objc func touchPopupBg(sender: UITapGestureRecognizer) {
        LogPrint("popupBG")
        self.dismiss(animated: true)
    }
    
    @objc func touchConfirm(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
        
        if popupState == "" {
            
        } else if popupState == "networkError" {
            
            hideAnim(type: .none, position: .none) { }
            
        } else if popupState == "calendarOverDay" {
            
            hideAnim(type: .none, position: .none) { }
            
        } else if popupState == "appUpdate" {
            
            hideAnim(type: .none, position: .none) { }
            
            let userInfoList: [AnyHashable: Any] = [
                "update": "Y"
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callAppUpdate"), object: nil, userInfo: userInfoList)
        
        } else if popupState == "logout_success" {
            
            let appDelegate: AppDelegate = AppDelegate().sharedInstance()
            appDelegate.moveToLogin()
        }
        
    }
    
}

