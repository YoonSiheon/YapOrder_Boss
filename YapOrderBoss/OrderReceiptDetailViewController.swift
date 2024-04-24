//
//  OrderReceiptDetailViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/07.
//

import Foundation
import UIKit
import SwiftyJSON

class OrderReceiptDetailViewController: UIViewController {
    
    var cellHeight: [CGFloat] = [165, 55, 0]    //[2] = billingCellHeight
    var cellProductHeight: [CGFloat] = []
    
    var billingCellHeight: CGFloat = 0          //376, 408
    var reservationViewHeight: CGFloat = 0      //92, 124
    
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageHomeView: UIView!
    @IBOutlet weak var imageHome: UIImageView!
    
    
    
    @IBOutlet weak var lableTitle: UILabel! {
        didSet {
            lableTitle.text = "order_detail_title".localized()
        }
    }
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var CustomTableView: UITableView!
    
    //***************************************************************//
    
    var accessToken: String = ""
    var storeCode: String = ""
    var pushId: Int64 = 0
    var posNo: String = ""
    
    //상품 셀 카운트
    var productCellCount: Int64 = 0
    //오늘의 할인 셀 카운트(할인이 있을시 카운트 증가)
    var discountCellCount: Int64 = 0
    
    //10, 11, 12, 13
    var orderStatus: Int = 0
    
    var isLoadingShow: Bool = false
    var isMoveToHome = false
    
    var orderId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        imageHome.image = UIImage(named:"order_home")
        
        imageBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageBack)))
        imageHome.isHidden = true
        imageHomeView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRemoveObserver(_:)), name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callDetailOrderStateChange(_:)), name: NSNotification.Name("callDetailOrderStateChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPushOrderReceiptDetail(_:)), name: NSNotification.Name("callPushOrderReceiptDetail"), object: nil)
        
        self.tabBarController?.tabBar.isHidden = true
        
        CustomTableView.delegate = self
        CustomTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        GlobalShareManager.shared().isMoveToDetail = true
        
        defaultInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
        
        LogPrint("isMoveToDetail:\(GlobalShareManager.shared().isMoveToDetail)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
        
        cellProductHeight.removeAll()
        productCellCount = 0
        discountCellCount = 0
        
        GlobalShareManager.shared().orderDetailArray.removeAll()
        GlobalShareManager.shared().orderDiscountArray.removeAll()
        GlobalShareManager.shared().orderProductArray.removeAll()
        GlobalShareManager.shared().optionName.removeAll()
        GlobalShareManager.shared().optionAmount.removeAll()
        
        if isMoveToHome {
            self.tabBarController?.tabBar.isHidden = false
            self.tabBarController?.selectedIndex = 0
            GlobalShareManager.shared().selectTabIndex = 0
        }
    }
    
    @objc func callRemoveObserver(_ notification: Notification) {
        LogPrint("callRemoveObserver - OrderReceiptDetailViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callRemoveObserver"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToForeground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToBackground"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callDetailOrderStateChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callPushOrderReceiptDetail"), object: nil)
    }
    
    @objc func appMovedToForeground() {
        LogPrint("appMovedToForeground")
        
        getOrderDetail(orderId: self.orderId)
    }
    
    @objc func appMovedToBackground() {
        LogPrint("appMovedToBackground")
    }
    
    func defaultInit() {
        
        accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        storeCode = GlobalShareManager.shared().getLocalData(GLOBAL_STORE_CODE) as? String ?? ""
        pushId = GlobalShareManager.shared().getLocalData(GLOBAL_PUSHID) as? Int64 ?? 0
        posNo = GlobalShareManager.shared().getLocalData(GLOBAL_POSNO) as? String ?? ""
        
    }
    
    @objc func callPushOrderReceiptDetail(_ notification: Notification) {
        LogPrint("callPushOrderReceiptDetail")
        
        var message = ""
        var status = ""
        var popupStatus = ""
        
        if let userInfo = notification.userInfo as? [String: Any] {
            message = userInfo["message"] as? String ?? ""
            status = userInfo["orderStatus"] as? String ?? ""
        }
        
        //initLoadView()
        
        let bellName = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_BELL_NAME) as? String ?? BELL_NAME_DEFAULT
        if bellName == BELL_NAME_DEFAULT {               //기본음
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
    
    func getOrderDetail(orderId: Int) {
        
        let accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        
        DispatchQueue.main.async {
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
                            
                            GlobalShareManager.shared().orderDetailArray = orderDetailResult.dictionaryObject!
                            GlobalShareManager.shared().orderDiscountArray = orderDiscountResult.arrayValue.compactMap({orderDiscountListData($0)})
                            GlobalShareManager.shared().orderProductArray = orderProductResult.arrayValue.compactMap({orderProductListData($0)})
                            
                            self.CustomTableView.reloadData()
                            
                            self.isLoadingShow = false
                            LoadingView.hideLoading()
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET ORDER DETAIL FAIL")
                        
                        self.isLoadingShow = false
                        LoadingView.hideLoading()
                    }
                } else {
                    LogPrint("NETWORK FAIL - getOrderDetail")
                    
                    self.isLoadingShow = false
                    LoadingView.hideLoading()
                }
            })
        }
    }
    
    @objc func touchImageBack(sender: UITapGestureRecognizer) {
        LogPrint("touchImageBack")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func touchImageHome(sender: UITapGestureRecognizer) {
        LogPrint("touchImageHome")
        
        isMoveToHome = true
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func callDetailOrderStateChange(_ notification: Notification) {
        LogPrint("callDetailOrderStateChange")
        
        self.navigationController?.popViewController(animated: true)
        
        let userInfo = notification.userInfo as! [String: Any]
        
        let userInfoList: [AnyHashable: Any] = [
            "orderCategory": userInfo["orderCategory"] as? Int ?? -1,
            "productName": userInfo["productName"] as? String ?? "",
            "productAmount": userInfo["productAmount"] as? String ?? "",
            "orderId": userInfo["orderId"] as? String ?? "",
            "saleId": userInfo["saleId"] as? String ?? "",
            "orderStatus": userInfo["orderStatus"] as? String ?? "",
            "orderType": userInfo["orderType"] as? String ?? "",
            "cancelType": userInfo["cancelType"] as? String ?? "",
            "cancelReason": userInfo["cancelReason"] as? String ?? ""
        ]
        NotificationCenter.default.post(name: NSNotification.Name("callOrderStateChange"), object: nil, userInfo: userInfoList)
    }
}

extension OrderReceiptDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LogPrint("select cell - section : \(indexPath.section) , index : \(indexPath.row)")
    }
    
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = 1 + productCellCount + discountCellCount + 1
        return Int(count)
    }
    
    
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //LogPrint("heightForRowAt : \(indexPath.row)")
        
        var height : CGFloat = 0.0
        
        if indexPath.row == 0 {
            height = cellHeight[0]
        } else if indexPath.row > 0 && productCellCount == 0 {
            height = billingCellHeight //cellHeight[2]
        } else if indexPath.row > 0 && productCellCount > 0 {

            if indexPath.row > 0 && indexPath.row <= productCellCount {             // product 만 있을때
                height = cellProductHeight[Int(indexPath.row) - 1]
            } else {                                                                // product 와 discountList 가 있을때
                
                if discountCellCount > 0 {
                    
                    //productCode 가 없는 = 제품 할인이 아닌 프로모션 할인이 있는지 체크
                    let discountArray = GlobalShareManager.shared().orderDiscountArray
                    var discountCount: Int = 0
                    for i in stride(from: 0, to: discountArray.count, by: 1) {
                        if discountArray[i].productCode!.count == 0 {
                            discountCount += 1
                        }
                    }
                    
                    if indexPath.row > 0 && indexPath.row == productCellCount + discountCellCount {
                        if discountCount == 1 {                                     // 오늘의 할인, 이번달 할인 등 할인이 있을때(discountType == "01")
                            height = cellHeight[1]
                        } else {                                                    // 쿠폰 할인 등 할인이 있을때(discountType == "02")
                            height = CGFloat(discountCount) * (cellHeight[1]/5 * 4)
                        }
                    } else {
                        height = billingCellHeight //cellHeight[2]                                      // discountList 가 없을때 고객정보 + 주문금액
                    }
                } else {                                                            // discountList 가 없을때 고객정보 + 주문금액
                    height = billingCellHeight //cellHeight[2]
                }
            }
        }
        
        return height
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //LogPrint("tableView count : \(indexPath), \(indexPath.row)")
        
        if indexPath.row == 0 {
            
            let detailArray = GlobalShareManager.shared().orderDetailArray
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "DetailOrderNumberCell", for: indexPath) as! DetailOrderNumberCell
            
            let orderTypeName = detailArray["orderTypeName"] as! String
            if orderTypeName.contains("매장예약") {
                cell.imageOrderType.image = UIImage(named:"order_reser_inside")
                
            } else if orderTypeName.contains("포장예약") {
                cell.imageOrderType.image = UIImage(named:"order_reser_takeout")
                
            } else if orderTypeName.contains("매장식사") {
                cell.imageOrderType.image = UIImage(named:"order_inside")
                
            } else if orderTypeName.contains("포장") {
                cell.imageOrderType.image = UIImage(named:"order_takeout")
            }
            cell.labelOrderNumber.text = "order_wait_number".localized() + "\(detailArray["waitNo"] ?? "")"
            cell.labelOrderProduct.text = "order_detail_product_product".localized() + " \(detailArray["productCount"] ?? "")" + "order_detail_product_count".localized()
            let receiptDate = getReceiptDate(date: detailArray["orderTime"] as! String)
            cell.labelOrderTime.text = "\(receiptDate.strDate)(\(receiptDate.strWeek)) \(receiptDate.strTime)"
            
            let tempStatus = detailArray["orderStatus"] as? String ?? ""
            //접수대기
            if tempStatus == TAB_ORDER_STATUS_ORDER {
                cell.labelOrderType.textColor = COMMON_ORANGE
                
                cell.labelOrderType.text = "order_status_order".localized()
            
            } //처리중 - 상품준비
            else if tempStatus == TAB_ORDER_STATUS_ORDERCOMPLETE {
                cell.labelOrderType.textColor = COMMON_ORANGE
                
                cell.labelOrderType.text = "order_status_order_complete".localized()
                
            } //처리중 - 예약대기
            else if tempStatus == TAB_ORDER_STATUS_RESERVATIONWAITTING {
                cell.labelOrderType.textColor = COMMON_ORANGE
                
                cell.labelOrderType.text = "order_status_reservation".localized()
                
            } //완료
            else if tempStatus == TAB_ORDER_STATUS_PRODUCTCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPDELAY || tempStatus == TAB_ORDER_STATUS_PICKUPDELAYCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPWAITTING {
                cell.labelOrderType.textColor = COMMON_ORANGE
                
                cell.labelOrderType.text = "order_status_product_complete".localized()
                
            } //취소
            else if tempStatus == TAB_ORDER_STATUS_ORDERCANCEL {
                cell.labelOrderType.textColor = COMMON_GRAY2
                
                cell.labelOrderType.text = "order_status_cancel".localized()
            }
            
            return cell
            
        } else if indexPath.row > 0 && indexPath.row < productCellCount + 1 {
            
            // product cell
            // 할인이 있는 체크
            // option 이 있는지 체크
            
            GlobalShareManager.shared().optionName.removeAll()
            GlobalShareManager.shared().optionAmount.removeAll()
            
            let productArray = GlobalShareManager.shared().orderProductArray
            
            var productNumber: String = ""
            var productName: String = ""
            var productQuantity: String = ""
            var productAmount: String = ""
            var productCode: String = ""
            
            productNumber = String(productArray[indexPath.row - 1].orderSeq ?? 0)
            productName = productArray[indexPath.row - 1].productName ?? ""
            productQuantity = String(productArray[indexPath.row - 1].saleQuantity ?? 0)
            productAmount = String(Int(productArray[indexPath.row - 1].salePrice ?? 0).toComma()) //realSaleAmount //salePrice //saleAmount
            productCode = productArray[indexPath.row - 1].productCode ?? ""
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "DetailOrderProductCell", for: indexPath) as! DetailOrderProductCell
            
            cell.labelNumber.text = productNumber
            cell.labelProduct.text = productName
            cell.labelQuantity.text = productQuantity
            cell.labelSaleAmount.text = productAmount
            
            // 할인 리스트에서 현재 product code 와 같은 할인 항목이 있을 경우 -> option List 에 이름과 가격을 추가
            let discountArray = GlobalShareManager.shared().orderDiscountArray
            outerLoop:for i in stride(from: 0, to: discountArray.count, by: 1) {
                if discountArray[i].productCode == productCode {
                    
                    if discountArray[i].discountAmount! > 0 {
                        
                        let name = discountArray[i].discountName ?? ""
                        let amount = Int(discountArray[i].discountAmount ?? 0)
                        
                        GlobalShareManager.shared().optionName.append(name)
                        GlobalShareManager.shared().optionAmount.append((amount * -1).toComma())
                        
                        break outerLoop
                    }
                }
            }
            
            // product 에서 option 이 있을 경우 -> option List 에 이름과 가격을 추가
            let optionArray = productArray[indexPath.row - 1].optionList!
            for i in stride(from: 0, to: optionArray.count, by: 1) {
                if optionArray.count > 0 {
                    
                    let optionDic: [String: Any] = optionArray[i].rawValue as! [String : Any]
                    let name = optionDic["productName"] as? String ?? ""
                    let amount = Int(optionDic["saleAmount"] as? Int64 ?? 0)
                    
                    GlobalShareManager.shared().optionName.append(name)
                    GlobalShareManager.shared().optionAmount.append(amount.toComma())
                }
            }
            
            // option List 를 확인하여 갯수를 가져와서 product cell 의 높이를 구한다
            let optionCount = GlobalShareManager.shared().optionName.count
            cell.addDiscountList(count: optionCount)
            
            return cell
            
        } else if indexPath.row > 0 && indexPath.row < productCellCount + discountCellCount + 1 {
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "DetailOrderDiscountCell", for: indexPath) as! DetailOrderDiscountCell
            cell.addDiscountList()
            
            return cell
            
        } else {
            
            let detailArray = GlobalShareManager.shared().orderDetailArray
            
            let cell = CustomTableView.dequeueReusableCell(withIdentifier: "DetailOrderBillingCell", for: indexPath) as! DetailOrderBillingCell
            cell.superView = self
            cell.orderStatus = self.orderStatus
            cell.constraintResevationViewHeight.constant = self.reservationViewHeight
            
            let orderType = detailArray["orderType"] as! String
            
            if orderType == "03" || orderType == "05" {
                
                cell.labelMemberReservation.isHidden = false
                cell.labelReservation.isHidden = false
                
                var reservationTime = detailArray["reservationTime"] as! String
                let reservationCount = detailArray["reservationPersonCount"] as! Int64
                
                let reservationDate = getReceiptDate(date: reservationTime)
                
                if reservationCount > 0 {
                    reservationTime = reservationDate.strTime + " (" + String(reservationCount) + "view_people".localized() + ")"
                } else {
                    reservationTime = reservationDate.strTime
                }
                
                cell.labelMemberReservation.text = "order_detail_reservation".localized()
                cell.labelReservation.text = reservationTime
                
            } else if orderType == "01" || orderType == "02" {
                
                cell.labelMemberReservation.isHidden = false
                cell.labelReservation.isHidden = false
                
                let tableName = detailArray["tableName"] as? String ?? ""
                
                cell.labelMemberReservation.text = "order_detail_reservation_table".localized()
                cell.labelReservation.text = tableName
                
            } else {
                
                cell.labelMemberReservation.isHidden = true
                cell.labelReservation.isHidden = true
            }
            
            var phoneNumber: String = detailArray["memberPhone"] as! String
            phoneNumber.insert("-", at:phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
            phoneNumber.insert("-", at:phoneNumber.index(phoneNumber.startIndex, offsetBy: 8))
            cell.labelPhone.text = phoneNumber
            
            var memo = detailArray["memo"] as? String ?? "-"
            if memo.count < 1 {
                memo = "-"
            }
            cell.labelMemo.text = memo
            
            cell.labelTotalSaleAmount.text = "\(String(Int(detailArray["saleAmount"] as? Int64 ?? 0).toComma()))" + "view_amount".localized()
            let discountAmount = Int(detailArray["discountAmount"] as? Int64 ?? 0)
            var strDiscountAmount: String = ""
            if discountAmount > 0 {                 // 할인금액이 있을시 '-' 표시
                strDiscountAmount = "-\(String(discountAmount.toComma()))" + "view_amount".localized()
            } else {                                // 할인금액이 없을시 0원 표시
                strDiscountAmount = "\(String(discountAmount.toComma()))" + "view_amount".localized()
            }
            cell.labelTotalDiscountAmount.text = strDiscountAmount
            cell.labelPaymentMethodName.text = detailArray["paymentMethodName"] as? String
            cell.labelTotalPayAmount.text = "\(String(Int(detailArray["payAmount"] as? Int64 ?? 0).toComma()))" + "view_amount".localized()
            
            let tempStatus = detailArray["orderStatus"] as! String
            //접수대기
            if tempStatus == TAB_ORDER_STATUS_ORDER {
                
                cell.viewOneButton.isHidden = true
                cell.labelOneButton.isHidden = true
                cell.viewCancel.isHidden = false
                cell.labelCancel.isHidden = false
                cell.viewConfirm.isHidden = false
                cell.labelConfirm.isHidden = false
                cell.labelConfirm.text = "order_detail_button_confirm".localized()
                cell.labelCancel.text = "order_detail_button_cancel".localized()

            } //처리중
            else if tempStatus == TAB_ORDER_STATUS_ORDERCOMPLETE || tempStatus == TAB_ORDER_STATUS_RESERVATIONWAITTING {
                
                cell.viewOneButton.isHidden = true
                cell.labelOneButton.isHidden = true
                cell.viewCancel.isHidden = false
                cell.labelCancel.isHidden = false
                cell.viewConfirm.isHidden = false
                cell.labelConfirm.isHidden = false
                cell.labelConfirm.text = "order_search_complete".localized()
                cell.labelCancel.text = "order_detail_button_cancel".localized()

            } //완료
            else if tempStatus == TAB_ORDER_STATUS_PRODUCTCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPDELAY || tempStatus == TAB_ORDER_STATUS_PICKUPDELAYCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPWAITTING {

                cell.viewOneButton.isHidden = false
                cell.labelOneButton.isHidden = false
                cell.viewCancel.isHidden = true
                cell.labelCancel.isHidden = true
                cell.viewConfirm.isHidden = true
                cell.labelConfirm.isHidden = true
                cell.labelOneButton.text = "order_detail_button_onebutton".localized()

            } //취소
            else if tempStatus == TAB_ORDER_STATUS_ORDERCANCEL {
                
                cell.viewOneButton.isHidden = true
                cell.labelOneButton.isHidden = true
                cell.viewCancel.isHidden = true
                cell.labelCancel.isHidden = true
                cell.viewConfirm.isHidden = true
                cell.labelConfirm.isHidden = true
            }
            
            return cell
        }
    }
    
}

extension OrderReceiptDetailViewController: UIScrollViewDelegate {

    //스크롤 방향성
    func scrollDirection(scrollView: UIScrollView) {
        let velocity: CGFloat = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if velocity < 0 {
//            LogPrint("UP")
        } else if velocity > 0 {
//            LogPrint("DOWN")
        }
    }

    //스크롤 되는 동안 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LogPrint("table scrollViewDidScroll")

        scrollDirection(scrollView: scrollView)

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        //LogPrint("1:\(offsetY),  2:\(contentHeight),  3:\(height)")
        if offsetY != 0 {
            setViewShadow(view: topView, type: "title")
        } else {
            setViewShadowDisable(view: topView, type: "title")
        }

        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            
//            if isPaging == false && hasNextPage {
//
//                isPaging = true // 현재 페이징이 진행 되는 것을 표시
//                // Section 1을 reload하여 로딩 셀을 보여줌 (페이징 진행 중인 것을 확인할 수 있도록)
//                DispatchQueue.main.async {
//                    self.CustomTableView.reloadSections(IndexSet(integer: 1), with: .none)
//                }
//
//                // 페이징 메소드 호출
//                self.paging()
//            }
        }
    }

    //스크롤 시작 될때 호출
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //LogPrint("table scrollViewWillBeginDragging")
    }

    //스크롤 끝났을때 호출
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //LogPrint("table scrollViewDidEndDragging")
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //LogPrint("table scrollViewWillEndDragging")
    }

    //스크롤링이 끝났을때 호출
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //LogPrint("table scrollViewDidEndDecelerating")
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //LogPrint("table scrollViewDidEndScrollingAnimation")
    }
    
}
