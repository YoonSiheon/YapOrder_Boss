//
//  OrderSearchCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/03.
//

import Foundation
import UIKit

class OrderSearchCell: UITableViewCell {
    
    var superView: UIViewController!
    
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var tfSearchName: UITextField! {
        didSet {
            tfSearchName.placeholder = "order_tf_search_placeholder".localized()
        }
    }
    @IBOutlet weak var btnSearch: UIButton! {
        didSet {
            btnSearch.setTitle("order_search_button".localized(), for: .normal)
        }
    }
    
    var strSearchName: String = ""
    var strStartDate: String = ""
    var strEndDate: String = ""
    var strSearchType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tfSearchName.autocorrectionType = .no
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callbackStartDate(_:)), name: NSNotification.Name("callbackStartDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callbackEndDate(_:)), name: NSNotification.Name("callbackEndDate"), object: nil)
        
        tfSearchName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEndOnExit)
        
        setupPopupButton()
    }
    
    func setupPopupButton() {
        let popupButtonAll = { (action: UIAction) in
            LogPrint("popupButtonAll")
            
            self.strSearchType = ""
        }
        let popupButtonOrder = { (action: UIAction) in
            LogPrint("popupButtonOrder")
            
            self.strSearchType = TAB_ORDER_STATUS_ORDER
        }
        let popupButtonReservation = { (action: UIAction) in
            LogPrint("popupButtonReservation")
            
            self.strSearchType = TAB_ORDER_STATUS_RESERVATIONWAITTING
        }
        let popupButtonOrderComplete = { (action: UIAction) in
            LogPrint("popupButtonReady")
            
            self.strSearchType = TAB_ORDER_STATUS_ORDERCOMPLETE
        }
        let popupButtonComplete = { (action: UIAction) in
            LogPrint("popupButtonComplete")
            
            self.strSearchType = TAB_ORDER_STATUS_PRODUCTCOMPLETE
        }
        let popupButtonCancel = { (action: UIAction) in
            LogPrint("popupButtonCancel")
            
            self.strSearchType = TAB_ORDER_STATUS_ORDERCANCEL
        }
        
        popupButton.menu = UIMenu(children: [
            UIAction(title:"order_search_all".localized(), handler: popupButtonAll),
            UIAction(title:"order_search_order".localized(), handler: popupButtonOrder),
            UIAction(title:"order_search_reservation".localized(), handler: popupButtonReservation),
            UIAction(title:"order_search_order_complete".localized(), handler: popupButtonOrderComplete),
            UIAction(title:"order_search_complete".localized(), handler: popupButtonComplete),
            UIAction(title:"order_search_cancel".localized(), handler: popupButtonCancel)
        ])
        
        popupButton.showsMenuAsPrimaryAction = true
    }
    
    func setupDate(startDate: String, endDate: String) {
        self.strStartDate = startDate
        self.strEndDate = endDate
        
        btnStartDate.setTitle(self.strStartDate, for: .normal)
        btnEndDate.setTitle(self.strEndDate, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfSearchName.endEditing(true)
        
        LogPrint("touchesBegan")
        
        let textName = tfSearchName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textName.count == 0 {
            strSearchName = ""
        } else {
            strSearchName = textName
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearchName.resignFirstResponder()
        
        LogPrint("textFieldShouldReturn")
        
        let textName = tfSearchName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textName.count == 0 {
            strSearchName = ""
        } else {
            strSearchName = textName
        }
        
        return true
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {

        LogPrint("textFieldDidChange - end")
        
        let textName = tfSearchName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textName.count == 0 {
            strSearchName = ""
        } else {
            strSearchName = textName
        }
    }
    
    @objc func callbackStartDate(_ notification: Notification) {
        LogPrint("callbackStartDate")
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let startDate = userInfo["startDate"] as? String {
                self.strStartDate = startDate
            }
        }
        
        btnStartDate.setTitle(self.strStartDate, for: .normal)
    }
    
    @objc func callbackEndDate(_ notification: Notification) {
        LogPrint("callbackEndDate")
        
        if let userInfo = notification.userInfo as? [String: Any] {
            if let endDate = userInfo["endDate"] as? String {
                self.strEndDate = endDate
            }
        }
        
        btnEndDate.setTitle(self.strEndDate, for: .normal)
    }
    
    @IBAction func actionStartDate(_ sender: Any) {
        LogPrint("actionStartDate")
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupCalendarViewController") as? PopupCalendarViewController {
            viewController.popupType = "calendar"
            viewController.state = "startDate"
            viewController.date = self.strStartDate.toAllDate()
            viewController.showAnim(vc: self.superView, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
    }
    
    @IBAction func actionEndDate(_ sender: Any) {
        LogPrint("actionEndDate")
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupCalendarViewController") as? PopupCalendarViewController {
            viewController.popupType = "calendar"
            viewController.state = "endDate"
            viewController.date = self.strEndDate.toAllDate()
            viewController.showAnim(vc: self.superView, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
    }
    
    @IBAction func actionSearchButton(_ sender: Any) {
        LogPrint("actionSearchButton")
        
        tfSearchName.endEditing(true)
        self.strSearchName = tfSearchName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        btnStartDate.setTitle(self.strStartDate, for: .normal)
        btnEndDate.setTitle(self.strEndDate, for: .normal)
        
        let userInfoList: [AnyHashable: Any] = [
            "searchType": self.strSearchType,
            "startDate": self.strStartDate,
            "endDate": self.strEndDate,
            "searchName": self.strSearchName
        ]
        NotificationCenter.default.post(name: NSNotification.Name("callOrderSearch"), object: nil, userInfo: userInfoList)
    }
    
    
}
