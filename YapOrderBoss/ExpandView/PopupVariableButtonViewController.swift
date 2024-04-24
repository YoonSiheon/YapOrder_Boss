//
//  PopupVariableButtonViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/16.
//

import Foundation
import UIKit

class PopupVariableButtonViewController: BasePopupViewController {
    
    @IBOutlet weak var constraintPopupHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewPopup: UIView!
//    @IBOutlet weak var viewButton: UIView!
//    @IBOutlet weak var labelButton: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTitleDescription: UILabel!
    
    
    var popupType: String = ""  //cancel 인지 estimateTime
    var buttonCount: Int = 0    //버튼읜 갯수
    var cellSelectCount: Int = -1   //누른 버튼의 index
    
    var popupCategory: Int = 0
    var orderProductName: String = ""
    var orderProductAmount: Int64 = 0
    var orderId: Int64 = 0
    var saleId: Int64 = 0
    var orderStatus: String = ""
    var orderType: String = ""
    
    @IBOutlet weak var CustomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        self.baseViewBack = self.viewBack
        self.baseViewPopup = self.viewPopup
        self.basePopupType = self.popupType
        
        CustomTableView.delegate = self
        CustomTableView.dataSource = self
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchBackView)))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchBackView)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        buttonCount = 0
        
        if popupType == "cancel" {
            
            buttonCount = GlobalShareManager.shared().orderCancelReasonArray.count
            
            labelTitle.text = "popup_order_cancelreason_title".localized()
            labelTitleDescription.text = "popup_order_cancelreason_description".localized()
            
            constraintPopupHeight.constant = POPUP_VARIABLE_TITLE_HEIGHT + (POPUP_VARIABLE_CELL_HEIGHT * CGFloat(buttonCount))
            
        } else if popupType == "estimateTime" {
            
            buttonCount = GlobalShareManager.shared().orderEstimateTimeArray.count
            
            labelTitle.text = "popup_order_estimatetime_tile".localized()
            labelTitleDescription.text = "popup_order_estimatetime_description".localized()
            
            constraintPopupHeight.constant = POPUP_VARIABLE_TITLE_HEIGHT + (POPUP_VARIABLE_CELL_HEIGHT * CGFloat(buttonCount))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func touchBackView(_ sender: UIDatePicker) {
        LogPrint("touchBackView")
        hideAnim(type: .none, position: .none) { }
    }
    
}

extension PopupVariableButtonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        LogPrint("willSelect - section : \(indexPath.section) , index : \(indexPath.row)")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LogPrint("select cell - section : \(indexPath.section) , index : \(indexPath.row)")
        
        self.cellSelectCount = indexPath.row
        
        CustomTableView.reloadData()
        
        if popupType == "cancel" {
            
            let userInfoList: [AnyHashable: Any] = [
                "orderCategory": self.popupCategory,
                "productName": self.orderProductName,
                "productAmount": String(self.orderProductAmount),
                "orderId": String(self.orderId),
                "saleId": String(self.saleId),
                "orderStatus": self.orderStatus,
                "orderType": self.orderType,
                "cancelType": GlobalShareManager.shared().orderCancelReasonArray[indexPath.row].cancelReasonType!,
                "cancelReason": GlobalShareManager.shared().orderCancelReasonArray[indexPath.row].cancelReason!
            ]
            
            let type = self.popupCategory - 10
            if type >= 0 {
                NotificationCenter.default.post(name: NSNotification.Name("callDetailOrderStateChange"), object: nil, userInfo: userInfoList)
                
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("callOrderStateChange"), object: nil, userInfo: userInfoList)
            }
            
        } else if popupType == "estimateTime" {
            
            let type = self.popupCategory - 10
            if type > 0 {
                
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
                
            } else {
                
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
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.hideAnim(type: .none, position: .none) { }
        }
    }
    
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = buttonCount
        return count
    }
    
    
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //LogPrint("heightForRowAt : \(indexPath.row)")
        
        let height : CGFloat = 63.0
        
        return height
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //LogPrint("tableView count : \(indexPath), \(indexPath.row)")
        
        if popupType == "cancel" {
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "PopupVariableButtonCell", for: indexPath) as! PopupVariableButtonCell
            cell.labelButton.text = GlobalShareManager.shared().orderCancelReasonArray[indexPath.row].cancelReason
            
            if self.cellSelectCount == indexPath.row {
                cell.setBorderColor(select: true)
            } else {
                cell.setBorderColor(select: false)
            }
            
            return cell
            
        } else if popupType == "estimateTime" {
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "PopupVariableButtonCell", for: indexPath) as! PopupVariableButtonCell
            cell.labelButton.text = String(GlobalShareManager.shared().orderEstimateTimeArray[indexPath.row])
            
            if self.cellSelectCount == indexPath.row {
                cell.setBorderColor(select: true)
            } else {
                cell.setBorderColor(select: false)
            }
            
            return cell
            
        } else {
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "PopupVariableButtonCell", for: indexPath) as! PopupVariableButtonCell
            
            return cell
        }
        
    }
    
}

