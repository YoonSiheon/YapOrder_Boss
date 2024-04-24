//
//  Popup2ButtonViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/11.
//

import UIKit

class Popup2ButtonViewController: BasePopupViewController {
    
    @IBOutlet weak var viewPopupView: UIView!
    @IBOutlet weak var labelPopupTitle: UILabel!
    @IBOutlet weak var labelPopupDescription: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelConfirm: UILabel!
    @IBOutlet weak var viewPopupBg: UIView!
    
    @IBOutlet weak var constraintPopupHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelDot1: UILabel! {
        didSet {
            labelDot1.text = "popup_storestop_dot".localized()
        }
    }
    @IBOutlet weak var labelDot2: UILabel! {
        didSet {
            labelDot2.text = "popup_storestop_dot".localized()
        }
    }
    @IBOutlet weak var labelDot3: UILabel! {
        didSet {
            labelDot3.text = "popup_storestop_dot".localized()
        }
    }
    
    @IBOutlet weak var labelDot1Message: UILabel! {
        didSet {
            labelDot1Message.text = "popup_storestop_description1".localized()
        }
    }
    @IBOutlet weak var labelDot2Message: UILabel! {
        didSet {
            labelDot2Message.text = "popup_storestop_description2".localized()
        }
    }
    @IBOutlet weak var labelDot3Message: UILabel! {
        didSet {
            labelDot3Message.text = "popup_storestop_description3".localized()
        }
    }
    
    var popupCategory: Int = 0
    var popupType: String = ""
    var strTitle: String = ""
    
    var orderProductName: String = ""
    var orderProductAmount: Int64 = 0
    var orderId: Int64 = 0
    var saleId: Int64 = 0
    var orderStatus: String = ""
    var orderType: String = ""
    var cancelType: String = ""
    var cancelReason: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        let width = getScreenSize().width
        
        self.baseViewBack = self.viewPopupBg
        self.baseViewPopup = self.viewPopupView
        self.basePopupType = self.popupType
        
        setViewShadow(view: viewPopupView)
        
        labelDot1.isHidden = true
        labelDot2.isHidden = true
        labelDot3.isHidden = true
        labelDot1Message.isHidden = true
        labelDot2Message.isHidden = true
        labelDot3Message.isHidden = true
        
        labelPopupDescription.isHidden = false
        
        //접수대기
        if popupCategory == TAB_ORDER_ORDERWAITING
        || popupCategory == TAB_ORDER_DETAIL_ORDERWAITING {           //Status = 0
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = strTitle
            labelPopupDescription.text = "popup_receipt_orderwaitting".localized()
            
            labelCancel.text = "action_cancel".localized()
            labelConfirm.text = "action_confirm".localized()
            
        } //처리중
        else if popupCategory == TAB_ORDER_ORDERPROCESSING
             || popupCategory == TAB_ORDER_DETAIL_ORDERPROCESSING {   //Status = 1
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = strTitle
            labelPopupDescription.text = "popup_receipt_orderprocessing".localized()
            
            labelCancel.text = "action_cancel".localized()
            labelConfirm.text = "action_confirm".localized()
            
        } //완료
        else if popupCategory == TAB_ORDER_ORDERCOMPLETE
             || popupCategory == TAB_ORDER_DETAIL_ORDERCOMPLETE {     //Status = 2
            
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupTitle.text = strTitle
            labelPopupDescription.text = "popup_receipt_ordercomplete".localized()
            
            labelCancel.text = "action_cancel".localized()
            labelConfirm.text = "action_confirm".localized()
            
        } //취소
        else if popupCategory == TAB_ORDER_ORDERCANCEL {       //Status = 3
            
        } //영업임시중지
        else if  popupCategory == POPUP_STATE_SALES_CLOSE {    //Status = 101
            
            labelDot1.isHidden = false
            labelDot2.isHidden = false
            labelDot3.isHidden = false
            labelDot1Message.isHidden = false
            labelDot2Message.isHidden = false
            labelDot3Message.isHidden = false
            
            labelPopupDescription.isHidden = true
            
            if width > 450 {
                constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_3LINE
            } else if width > 390 {
                constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_3LINE_WIDTH2
            } else {
                constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_3LINE_WIDTH3
            }
            labelPopupTitle.text = "popup_storestop_title".localized()
            
            labelCancel.text = "action_cancel".localized()
            labelConfirm.text = "action_storestop".localized()
            
        } // 로그아웃
        else if  popupCategory == POPUP_STATE_LOGOUT {
            
            labelPopupTitle.isHidden = true
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupDescription.text = "popup_logout_description".localized()
        }
        else if  popupCategory == POPUP_STATE_PERMISSION_CHECK {
            
            labelPopupTitle.text = "popup_permission_title".localized()
            constraintPopupHeight.constant = POPUP_TITLE_POPUP_HEIGHT_2LINE
            labelPopupDescription.text = "popup_permission_check_description".localized()
            
            labelCancel.text = "action_cancel".localized()
            labelConfirm.text = "action_setting".localized()
        }
        
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchCancel)))
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
//        self.dismiss(animated: true)
    }
    
    @objc func touchCancel(sender: UITapGestureRecognizer) {
        hideAnim(type: .none, position: .none) { }
        
    }
    
    @objc func touchConfirm(sender: UITapGestureRecognizer) {
//        self.dismiss(animated: true)
        hideAnim(type: .none, position: .none) { }
        
        //접수대기
        if popupCategory == TAB_ORDER_ORDERWAITING      //Status = 0    접수대기
        || popupCategory == TAB_ORDER_ORDERPROCESSING   //Status = 1    처리중
        || popupCategory == TAB_ORDER_ORDERCOMPLETE {   //Status = 2    완료
            
            let userInfoList: [AnyHashable: Any] = [
                "orderCategory": self.popupCategory,
                "productName": self.orderProductName,
                "productAmount": String(self.orderProductAmount),
                "orderId": String(self.orderId),
                "saleId": String(self.saleId),
                "orderStatus": self.orderStatus,
                "orderType": self.orderType
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callOrderStateChange"), object: nil, userInfo: userInfoList)
            
        } //취소
        else if popupCategory == TAB_ORDER_ORDERCANCEL {       //Status = 3
            
        } //영업임시중지
        
        else if popupCategory == TAB_ORDER_DETAIL_ORDERWAITING          //Status = 10
             || popupCategory == TAB_ORDER_DETAIL_ORDERPROCESSING       //Status = 11
             || popupCategory == TAB_ORDER_DETAIL_ORDERCOMPLETE {       //Status = 12
            
            let userInfoList: [AnyHashable: Any] = [
                "orderCategory": self.popupCategory,
                "productName": self.orderProductName,
                "productAmount": String(self.orderProductAmount),
                "orderId": String(self.orderId),
                "saleId": String(self.saleId),
                "orderStatus": self.orderStatus,
                "orderType": self.orderType
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callDetailOrderStateChange"), object: nil, userInfo: userInfoList)
            
        }
        else if  popupCategory == POPUP_STATE_SALES_CLOSE {    //Status = 101
            
            hideAnim(type: .none, position: .none) { }
            
            let userInfoList: [AnyHashable: Any] = [
                "bizStop": "Y"
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callSalesStop"), object: nil, userInfo: userInfoList)
            
        }
        else if  popupCategory == POPUP_STATE_LOGOUT {
            
            hideAnim(type: .none, position: .none) { }
            
            let userInfoList: [AnyHashable: Any] = [
                "isLogout": "Y"
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callLogout"), object: nil, userInfo: userInfoList)
        }
        else if  popupCategory == POPUP_STATE_PERMISSION_CHECK {
            
            hideAnim(type: .none, position: .none) { }
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
}
