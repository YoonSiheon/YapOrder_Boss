//
//  DetailOrderBillingCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/20.
//

import Foundation
import UIKit

class DetailOrderBillingCell: UITableViewCell {
    
    var superView: UIViewController!
    
    @IBOutlet weak var labelMemberPhone: UILabel! {
        didSet {
            labelMemberPhone.text = "order_detail_member_phone".localized()
            
        }
    }
    @IBOutlet weak var labelMemberMemo: UILabel! {
        didSet {
            labelMemberMemo.text = "order_detail_member_memo".localized()
        }
    }
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelMemo: UILabel!
    
    @IBOutlet weak var labelTotalSale: UILabel! {
        didSet {
            labelTotalSale.text = "order_detail_total_saleamount".localized()
        }
    }
    @IBOutlet weak var labelTotalDiscount: UILabel! {
        didSet {
            labelTotalDiscount.text = "order_detail_discountamount".localized()
        }
    }
    @IBOutlet weak var labelPaymentMethod: UILabel! {
        didSet {
            labelPaymentMethod.text = "order_detail_payment_method".localized()
        }
    }
    @IBOutlet weak var labelTotalPay: UILabel! {
        didSet {
            labelTotalPay.text = "order_detail_payamount".localized()
        }
    }
    @IBOutlet weak var labelTotalSaleAmount: UILabel!
    @IBOutlet weak var labelTotalDiscountAmount: UILabel!
    @IBOutlet weak var labelPaymentMethodName: UILabel!
    @IBOutlet weak var labelTotalPayAmount: UILabel!
    
    
    @IBOutlet weak var viewOneButton: UIView!
    @IBOutlet weak var labelOneButton: UILabel! {
        didSet {
            labelOneButton.text = "order_detail_button_onebutton".localized()
        }
    }
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var labelCancel: UILabel! {
        didSet {
            labelCancel.text = "order_detail_button_cancel".localized()
        }
    }
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var labelConfirm: UILabel! {
        didSet {
            labelConfirm.text = "order_detail_button_confirm".localized()
        }
    }
    
    //ResevationViewHeight = 92, 124
    @IBOutlet weak var constraintResevationViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var labelMemberReservation: UILabel!
    @IBOutlet weak var labelReservation: UILabel!
    
    //10, 11, 12, 13
    var orderStatus: Int = 0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOneButton.roundCorners(cornerRadius: 4, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        viewCancel.roundCorners(cornerRadius: 4, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        viewConfirm.roundCorners(cornerRadius: 4, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        viewOneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOneButton)))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchCancel)))
        viewConfirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchConfirm)))
    }
    
    @objc func touchOneButton(sender: UITapGestureRecognizer) {
        LogPrint("touchOneButton")
        
        let detailArray = GlobalShareManager.shared().orderDetailArray
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
            viewController.popupCategory = self.orderStatus
            viewController.strTitle = "order_wait_number".localized() + " \(detailArray["waitNo"] as? String ?? "")"
            viewController.orderProductName = detailArray["productName"] as? String ?? ""
            viewController.orderProductAmount = detailArray["saleAmount"] as? Int64 ?? 0
            viewController.orderId = detailArray["orderId"] as? Int64 ?? 0
            viewController.saleId = detailArray["saleId"] as? Int64 ?? 0
            viewController.orderStatus = detailArray["orderStatus"] as? String ?? ""
            viewController.orderType = detailArray["orderType"] as? String ?? ""
            viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, hidePopupTabbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
    }
    
    @objc func touchCancel(sender: UITapGestureRecognizer) {
        LogPrint("touchCancel")
        
        let detailArray = GlobalShareManager.shared().orderDetailArray
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVariableButtonViewController") as? PopupVariableButtonViewController {
            viewController.popupType = "cancel"
            viewController.popupCategory = self.orderStatus
            viewController.orderProductName = detailArray["productName"] as? String ?? ""
            viewController.orderProductAmount = detailArray["saleAmount"] as? Int64 ?? 0
            viewController.orderId = detailArray["orderId"] as? Int64 ?? 0
            viewController.saleId = detailArray["saleId"] as? Int64 ?? 0
            viewController.orderStatus = detailArray["orderStatus"] as? String ?? ""
            viewController.orderType = detailArray["orderType"] as? String ?? ""
            viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, hidePopupTabbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
        
    }
    
    @objc func touchConfirm(sender: UITapGestureRecognizer) {
        LogPrint("touchConfirm")
        
        let detailArray = GlobalShareManager.shared().orderDetailArray
        
        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
            viewController.popupCategory = self.orderStatus
            viewController.strTitle = "order_wait_number".localized() + " \(detailArray["waitNo"] as? String ?? "")"
            viewController.orderProductName = detailArray["productName"] as? String ?? ""
            viewController.orderProductAmount = detailArray["saleAmount"] as? Int64 ?? 0
            viewController.orderId = detailArray["orderId"] as? Int64 ?? 0
            viewController.saleId = detailArray["saleId"] as? Int64 ?? 0
            viewController.orderStatus = detailArray["orderStatus"] as? String ?? ""
            viewController.orderType = detailArray["orderType"] as? String ?? ""
            viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, hidePopupTabbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
        
    }
    
}
