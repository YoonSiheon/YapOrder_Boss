//
//  PopupNotificationViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/07.
//

import Foundation
import UIKit
import SnapKit

class PopupNotificationViewController: BasePopupViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var labelNotiMessage: UILabel!
    
    var popupType: String = ""
    var popupMessage: String = ""
    
    var popupStatus: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        self.baseViewBack = self.viewBack
        self.baseViewPopup = self.viewPopup
        self.basePopupType = self.popupType
        
        labelNotiMessage.text = popupMessage
        
        if popupStatus == "new" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
        } else if popupStatus == "change" {
            
            viewPopup.backgroundColor = .white
            labelNotiMessage.textColor = .black
        
        } else if popupStatus == "default_order" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
            soundDefaultOrder()
        
        } else if popupStatus == "default_reservation" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
            soundDefaultReservation()
            
        } else if popupStatus == "default_reservation_before10" {
            
            viewPopup.backgroundColor = .white
            labelNotiMessage.textColor = .black
            
            soundDefaultReservation_before10()
            
        } else if popupStatus == "limchangjung_order" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
            soundLimchangjungOrder()
            
        } else if popupStatus == "limchangjung_reservation" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
            soundLimchangjungReservation()
            
        } else if popupStatus == "limchangjung_reservation_before10" {
            
            viewPopup.backgroundColor = .white
            labelNotiMessage.textColor = .black
            
            soundLimchangjungReservation_before10()
            
        } else if popupStatus == "cancel" {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
        } else {
            
            viewPopup.backgroundColor = .black
            labelNotiMessage.textColor = .white
            
            labelNotiMessage.text = "popup_noti_etc".localized()
        }
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOnlyClose)))
        viewPopup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchClose)))
        
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
    
    @objc func touchOnlyClose(sender: UITapGestureRecognizer) {
        LogPrint("touchOnlyClose")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hideAnim(type: .move, position: .top) { }
        }
    }
    
    @objc func touchClose(sender: UITapGestureRecognizer) {
        LogPrint("touchClose")

        hideAnim(type: .move, position: .top) { }
        
        if popupStatus == "default_order"
        || popupStatus == "limchangjung_order" {
            
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERWAITING
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            self.tabBarController?.selectedIndex = 1
            GlobalShareManager.shared().selectTabIndex = 1
            
            NotificationCenter.default.post(name: NSNotification.Name("callReloadOrderReceiptView"), object: nil, userInfo: nil)
            
        } else if popupStatus == "default_reservation"
        || popupStatus == "default_reservation_before10"
        || popupStatus == "limchangjung_reservation"
        || popupStatus == "limchangjung_reservation_before10" {
            
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERPROCESSING
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            self.tabBarController?.selectedIndex = 1
            GlobalShareManager.shared().selectTabIndex = 1
            
            NotificationCenter.default.post(name: NSNotification.Name("callReloadOrderReceiptView"), object: nil, userInfo: nil)
            
        } else if popupStatus == "cancel" {
            
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERCANCEL
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            self.tabBarController?.selectedIndex = 1
            GlobalShareManager.shared().selectTabIndex = 1
            
            NotificationCenter.default.post(name: NSNotification.Name("callReloadOrderReceiptView"), object: nil, userInfo: nil)
        }
        
    }
    
}
