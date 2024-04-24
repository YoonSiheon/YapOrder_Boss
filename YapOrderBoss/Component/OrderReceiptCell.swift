//
//  File.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/16.
//

import Foundation
import UIKit
import SwiftyJSON

class OrderReceiptCell: UITableViewCell {
    
    var superView: UIViewController!

    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var imageOrderType: UIImageView!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelOrderType: UILabel!
    @IBOutlet weak var labelOrderDate: UILabel!
    @IBOutlet weak var labelOrderProduct: UILabel!
    
    @IBOutlet weak var viewReservation: UIView!
    @IBOutlet weak var labelReservation: UILabel!
    
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var labelCancel: UILabel! {
        didSet {
            labelCancel.text = "order_detail_button_cancel".localized()
        }
    }
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var labelConfirm: UILabel! {
        didSet {
            labelCancel.text = "order_detail_button_confirm".localized()
        }
    }
    @IBOutlet weak var viewOneButton: UIView!
    @IBOutlet weak var labelOneButton: UILabel! {
        didSet {
            labelCancel.text = "order_detail_button_onebutton".localized()
        }
    }
    
    //productName width 를 구하기 위해 똑같은 seperateLine * 0.5 사용
    @IBOutlet weak var viewSeperateLine: UIView!
    
    
    var categoryState: Int = 0
    
    // noti에 사용될 상품명, 상품가격
    // status 변경 - saleId, orderId, orderStatus, orderType, cancelType, cancelReson
    var orderProductName: String = ""
    var orderProductAmount: Int64 = 0
    var orderId: Int64 = 0
    var saleId: Int64 = 0
    var orderStatus: String = ""
    var orderType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        LogPrint("OrderReceiptCell")
        
        viewOneButton.roundCorners(cornerRadius: 4, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        viewCancel.roundCorners(cornerRadius: 4, maskedCorners: .layerMinXMaxYCorner)
        viewConfirm.roundCorners(cornerRadius: 4, maskedCorners: .layerMaxXMaxYCorner)
        
        viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchContent)))
        viewOneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOneButton)))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchCancel)))
        viewConfirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchConfirm)))
        
    }
    
    @objc func touchContent(sender: UITapGestureRecognizer) {
        LogPrint("touchContent : \(self.orderId)")
        
        if self.orderId != 0 {
            
            self.getOrderDetail(orderId: Int(self.orderId))
            
        }
    }
    
    @objc func touchOneButton(sender: UITapGestureRecognizer) {
        LogPrint("touchOneButton:\(categoryState)")

        if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
            viewController.popupCategory = self.categoryState
            viewController.strTitle = self.labelOrderNumber.text ?? ""
            viewController.orderProductName = self.orderProductName
            viewController.orderProductAmount = self.orderProductAmount
            viewController.orderId = self.orderId
            viewController.saleId = self.saleId
            viewController.orderStatus = self.orderStatus
            viewController.orderType = self.orderType
            viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
        }
    }
    
    @objc func touchCancel(sender: UITapGestureRecognizer) {
        LogPrint("touchCancel:\(categoryState)")
        
        //접수대기
        if categoryState == TAB_ORDER_ORDERWAITING {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVariableButtonViewController") as? PopupVariableButtonViewController {
                viewController.popupType = "cancel"
                viewController.popupCategory = self.categoryState
                viewController.orderProductName = self.orderProductName
                viewController.orderProductAmount = self.orderProductAmount
                viewController.orderId = self.orderId
                viewController.saleId = self.saleId
                viewController.orderStatus = self.orderStatus
                viewController.orderType = self.orderType
                viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
            }
            
        } //처리중
        else if categoryState == TAB_ORDER_ORDERPROCESSING {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVariableButtonViewController") as? PopupVariableButtonViewController {
                viewController.popupType = "cancel"
                viewController.popupCategory = self.categoryState
                viewController.orderProductName = self.orderProductName
                viewController.orderProductAmount = self.orderProductAmount
                viewController.orderId = self.orderId
                viewController.saleId = self.saleId
                viewController.orderStatus = self.orderStatus
                viewController.orderType = self.orderType
                viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
            }
            
        }
        
    }
    
    @objc func touchConfirm(sender: UITapGestureRecognizer) {
        LogPrint("touchConfirm:\(categoryState)")
        
        let cookTimeType = GlobalShareManager.shared().cookTimeType
        let cookTimeTypeText = GlobalShareManager.shared().cookTimeTypeText
        let cookTimeMinute = GlobalShareManager.shared().cookTimeMinute
        let estimateTimeArray = GlobalShareManager.shared().orderEstimateTimeArray
        
        //ysh test
        if categoryState == TAB_ORDER_ORDERWAITING {
            
            if cookTimeType == "01" {
                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                    viewController.popupCategory = self.categoryState
                    viewController.strTitle = self.labelOrderNumber.text ?? ""
                    viewController.orderProductName = self.orderProductName
                    viewController.orderProductAmount = self.orderProductAmount
                    viewController.orderId = self.orderId
                    viewController.saleId = self.saleId
                    viewController.orderStatus = self.orderStatus
                    viewController.orderType = self.orderType
                    viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
                }
                
            } else if cookTimeType == "02" {
                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                    viewController.popupCategory = self.categoryState
                    viewController.strTitle = self.labelOrderNumber.text ?? ""
                    viewController.orderProductName = self.orderProductName
                    viewController.orderProductAmount = self.orderProductAmount
                    viewController.orderId = self.orderId
                    viewController.saleId = self.saleId
                    viewController.orderStatus = self.orderStatus
                    viewController.orderType = self.orderType
                    viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
                }
                
            } else if cookTimeType == "03" {
                
                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVariableButtonViewController") as? PopupVariableButtonViewController {
                    viewController.popupType = "estimateTime"
                    viewController.popupCategory = self.categoryState
                    viewController.orderProductName = self.orderProductName
                    viewController.orderProductAmount = self.orderProductAmount
                    viewController.orderId = self.orderId
                    viewController.saleId = self.saleId
                    viewController.orderStatus = self.orderStatus
                    viewController.orderType = self.orderType
                    viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true,type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
                }
            }
            
        } else if categoryState == TAB_ORDER_ORDERPROCESSING {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                viewController.popupCategory = self.categoryState
                viewController.strTitle = self.labelOrderNumber.text ?? ""
                viewController.orderProductName = self.orderProductName
                viewController.orderProductAmount = self.orderProductAmount
                viewController.orderId = self.orderId
                viewController.saleId = self.saleId
                viewController.orderStatus = self.orderStatus
                viewController.orderType = self.orderType
                viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
            }
        }
        
    }
    
    func getOrderDetail(orderId: Int) {
        
        let accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        
        NetworkManager.shared().getOrderDetail(token: accessToken, orderId: orderId, completion: {(success, status, data) in
            if success {
                if (status == 200) {
                    LogPrint("GET getOrderDetail")

                    do {
                        GlobalShareManager.shared().orderDetailArray.removeAll()
                        GlobalShareManager.shared().orderDiscountArray.removeAll()
                        GlobalShareManager.shared().orderProductArray.removeAll()
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let jsonResult = try JSON(data: jsonData)
                        
                        let orderResult = jsonResult["data"]
                        let orderDetailResult = orderResult["order"]
                        let orderDiscountResult = orderResult["orderDiscountList"]
                        let orderProductResult = orderResult["orderProductList"]
//                        GlobalShareManager.shared().orderDetailArray = orderDetailResult.arrayValue.compactMap({orderReceiptDetailData($0)})
                        GlobalShareManager.shared().orderDiscountArray = orderDiscountResult.arrayValue.compactMap({orderDiscountListData($0)})
                        GlobalShareManager.shared().orderProductArray = orderProductResult.arrayValue.compactMap({orderProductListData($0)})
                        
                        GlobalShareManager.shared().orderDetailArray = orderDetailResult.dictionaryObject!
                        
//                        var detailArray = GlobalShareManager.shared().orderDetailArray
                        var discountArray = GlobalShareManager.shared().orderDiscountArray
                        let productArray = GlobalShareManager.shared().orderProductArray
                        
                        let orderType = orderDetailResult.dictionaryObject!["orderType"] as? String ?? ""
                        let productName = orderDetailResult.dictionaryObject!["productName"] as? String ?? ""
                        
                        //주문 상세페이지로 이동
                        if let viewController = UIStoryboard.init(name: "OrderReceipt", bundle: nil).instantiateViewController(withIdentifier: "OrderReceiptDetailViewController") as? OrderReceiptDetailViewController {
                            
                            viewController.modalTransitionStyle = .flipHorizontal
                            viewController.orderStatus = self.categoryState + 10
                            viewController.orderId = orderId
                            
                            if orderType == "01" || orderType == "02" || orderType == "03" || orderType == "05" {
                                
                                viewController.billingCellHeight = 408
                                viewController.reservationViewHeight = 124
                                
                            } else {
                                
                                viewController.billingCellHeight = 376
                                viewController.reservationViewHeight = 92
                            }
                            
                            //productCode 가 없는 = 제품 할인이 아닌 프로모션 할인이 있는지 체크
                            for i in stride(from: 0, to: discountArray.count, by: 1) {
                                if discountArray[i].productCode!.count == 0 {
                                    viewController.discountCellCount = 1
//                                    discountArray.remove(at: i)
                                }
                            }
                            
                            //할인리스트, 옵션리스트 확인
                            if productArray.count > 0 {
                                viewController.productCellCount = Int64(productArray.count)
                                
                                for i in stride(from: 0, to: productArray.count, by: 1) {
                                    
                                    var productDiscount: Int = 0
                                    // 할인 리스트에서 현재 product code 와 같은 할인 항목이 있을 경우
                                    outerLoop: for j in stride(from: 0, to: discountArray.count, by: 1) {
                                        if discountArray[j].productCode == productArray[i].productCode {
//                                            if (discountArray[j].discountCheck!.count == 0 &&
                                                //discountType 가 0 인것 예외?
                                            if discountArray[j].discountType!.count > 0 && Int(discountArray[j].discountAmount!) > 0 {
                                                productDiscount += 1
                                                discountArray[j].discountCheck = "check"
                                                break outerLoop
                                            }
                                        }
                                    }
                                    
                                    let optionArray = productArray[i].optionList
                                    let optionCount = optionArray!.count
                                    
                                    
                                    let productSize = productArray[i].productName!.size(withAttributes: [NSAttributedString.Key.font : self.labelConfirm.font!]).width
                                    let labelWidth = self.viewSeperateLine.frame.width * 0.5
                                    var line = Int(productSize / labelWidth)
                                    let line_temp = productSize.truncatingRemainder(dividingBy: labelWidth)
                                    
                                    if line > 0 && line_temp > 0 {
                                        line += 1
                                    }
                                    
                                    viewController.cellProductHeight.append(ORDER_DETAIL_PRODUCT_CELL_HEIGHT + CGFloat(line * 15) + (ORDER_DETAIL_PRODUCT_CELL_HEIGHT_OPTION * CGFloat(productDiscount)) + (ORDER_DETAIL_PRODUCT_CELL_HEIGHT_OPTION * CGFloat(optionCount)))
                                }
                            }
                            
                            self.superView.navigationController?.pushViewController(viewController, animated: true)
                        }
                        
                    } catch {

                    }

                } else {
                    LogPrint("GET STORE FAIL")
                }
            } else {
                LogPrint("NETWORK FAIL - getStore")
            }
        })
    }
    
}
