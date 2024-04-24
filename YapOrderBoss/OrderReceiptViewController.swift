//
//  OrderReceiptViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/10.
//

import Foundation
import UIKit
import WebKit
import SwiftyJSON

class OrderReceiptViewController: UIViewController {
    
    var cellHeight: [CGFloat] = [80, 291, 0]
    
    var cellEmptyHeight: CGFloat = 270
    var refreshControl = UIRefreshControl()
    
    //***************************************************************//
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var imageHomeButton: UIView!
    
    @IBOutlet weak var viewOrderToday: UIView!
    @IBOutlet weak var labelOrderToday: UILabel!
    @IBOutlet weak var viewOrderAll: UIView!
    @IBOutlet weak var labelOrderAll: UILabel!
    @IBOutlet weak var viewColorLine: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    //***************************************************************//
    
    @IBOutlet weak var CustomTableView: UITableView!
    
    //***************************************************************//
    
    var accessToken: String = ""
    var storeCode: String = ""
    var pushId: Int64 = 0
    var posNo: String = ""
    
    var tabLineLeftXPosition: CGFloat = 0.0
    var tabLineRightXPosition: CGFloat = 0.0
    
    // 오늘주문, 전체주문
    var typeOrderContent: Int = 0
    
    // 접수대기, 처리중, 완료, 취소
    var todayCategoryState: Int = 0
    
    var badgeCount: Int64 = 0
    var orderCount: Int64 = 0       //주문 건 수 cell용
    
    var orderTodayViewArray = Array<orderReceiptData>()
    
    // 검색 조건
    var startDate: String = ""
    var endDate: String = ""
    var searchName: String = ""
    var searchType: String = ""
    // 임시 검색 배열 - 페이징 처리를 위해 사용
    var searchArray = Array<orderReceiptData>()
    
    var pagingSize: Int = 20 // 검색시 검색되는 갯수
    var pagingCount: Int = 1 // 페이징 페이지(1 부터 시작)
    var isPaging: Bool = false // 현재 페이징 중인지 체크하는 flag
    var hasNextPage: Bool = false // 마지막 페이지 인지 체크 하는 flag
    
    var isLoadingShow: Bool = false
    
    var isSearchClick: Bool = false
    
    //***************************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        tabLineLeftXPosition = 0.0
        tabLineRightXPosition = getScreenSize().width/2 - 20
        
        typeOrderContent = TAB_ORDER_ORDERTODAY
        todayCategoryState = TAB_ORDER_ORDERWAITING
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRemoveObserver(_:)), name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReloadOrderReceiptView(_:)), name: NSNotification.Name("callReloadOrderReceiptView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPushOrderReceipt(_:)), name: NSNotification.Name("callPushOrderReceipt"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderWaitting(_:)), name: NSNotification.Name("callOrderWaitting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderING(_:)), name: NSNotification.Name("callOrderING"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderComplete(_:)), name: NSNotification.Name("callOrderComplete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderCancel(_:)), name: NSNotification.Name("callOrderCancel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderSearch(_:)), name: NSNotification.Name("callOrderSearch"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callOrderStateChange(_:)), name: NSNotification.Name("callOrderStateChange"), object: nil)
        
        CustomTableView.delegate = self
        CustomTableView.dataSource = self
        
        initRefresh()
        defaultInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        LogPrint("content: \(self.typeOrderContent)")
        
        accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        storeCode = GlobalShareManager.shared().getLocalData(GLOBAL_STORE_CODE) as? String ?? ""
        pushId = GlobalShareManager.shared().getLocalData(GLOBAL_PUSHID) as? Int64 ?? 0
        posNo = GlobalShareManager.shared().getLocalData(GLOBAL_POSNO) as? String ?? ""
        
        isLoadingShow = true
        LoadingView.showLoading()
        
        self.tabBarController?.tabBar.isHidden = false
        
        GlobalShareManager.shared().isMoveToDetail = false
        GlobalShareManager.shared().isMoveToOrder = false
        
        initLoadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
        LogPrint("isMoveToDetail:\(GlobalShareManager.shared().isMoveToDetail)")
        
        if isLoadingShow {
            DispatchQueue.main.asyncAfter(deadline: .now() + LOADING_DELAY_DEFAULT) {
                self.isLoadingShow = false
                LoadingView.hideLoading()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
        
        //badgeCount
        badgeCount = 0
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @objc func callRemoveObserver(_ notification: Notification) {
        LogPrint("callRemoveObserver - OrderReceiptViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callRemoveObserver"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToForeground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToBackground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callReloadOrderReceiptView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callPushOrderReceipt"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderWaitting"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderING"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderComplete"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderCancel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderSearch"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callOrderStateChange"), object: nil)
    }
    
    @objc func appMovedToForeground() {
        LogPrint("appMovedToForeground")
        
        if GlobalShareManager.shared().selectTabIndex == 1 {
            LogPrint("tabIndex 1 reload")
            
            initLoadView()
        } else if GlobalShareManager.shared().selectTabIndex == 0 {
            
            self.tabBarController?.selectedIndex = 0
            GlobalShareManager.shared().selectTabIndex = 0
        }
    }
    
    @objc func appMovedToBackground() {
        LogPrint("appMovedToBackground")
    }
    
    func defaultInit() {
        labelTitle.text = "order_title".localized()
        labelOrderToday.text = "order_ordertoday".localized()
        labelOrderAll.text = "order_orderall".localized()
        
        imageHome.image = UIImage(named:"order_home")
        
//        imageHome.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageHome)))
//        imageHomeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageHome)))
        imageHome.isHidden = true
        imageHomeButton.isHidden = true
        
        viewOrderToday.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderToday)))
        viewOrderAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderAll)))
        
        // tableView Swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.CustomTableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.CustomTableView.addGestureRecognizer(swipeRight)
    }
    
    func networkInit() {
        
        self.getOrderToday()
        self.getOrderSearch(startDate: self.startDate, endDate: self.endDate, searchName: self.searchName, isRefresh: true, isSearch: isSearchClick)
    }
    
    func initRefresh() {
        if self.typeOrderContent == TAB_ORDER_ORDERTODAY {
            refreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
//            refreshControl.backgroundColor = .white
//            refreshControl.tintColor = .purple
            refreshControl.attributedTitle = NSAttributedString(string: "새로고침 중")
            
            CustomTableView.refreshControl = refreshControl
        } else {
            CustomTableView.refreshControl = nil
        }
    }
    
    func initLoadView() {
        
        networkInit()
        
        updateTabAndCategory()
    }
    
    func paging() {
        
        self.pagingCount += 1
        LogPrint("pagingCount:\(self.pagingCount)")
        
        getOrderSearch(startDate: startDate, endDate: endDate, searchName: searchName)
        
        LogPrint("orderCount:\(self.orderCount)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + REFRESH_DELAY_TIME_DEFAULT) {
            //self.hasNextPage = self.orderCount > 0 ? false : true
            self.hasNextPage = true
            self.isPaging = false // 페이징이 종료 되었음을 표시
            
            self.CustomTableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    func updateTabAndCategory() {
        
        typeOrderContent = GlobalShareManager.shared().order_category_content
        todayCategoryState = GlobalShareManager.shared().order_category_status
        if typeOrderContent == TAB_ORDER_ORDERTODAY {
            typeOrderContent = TAB_ORDER_ORDERALL
            updateOrderToday()
        } else if typeOrderContent == TAB_ORDER_ORDERALL {
            updateOrderAll()
        }
        
    }
    
    func updateData(state: Int = 0) {
        
        GlobalShareManager.shared().order_category_status = state
        
        GlobalShareManager.shared().order_countOrder = 0
        GlobalShareManager.shared().order_countING = 0
        GlobalShareManager.shared().order_countComplete = 0
        GlobalShareManager.shared().order_countCancel = 0
        
        self.orderTodayViewArray.removeAll()
        
        let orderArray = GlobalShareManager.shared().orderTodayArray
        self.orderCount = 0
        
        var tempStatus:Int  = 0
        for num in stride(from: 0, to: orderArray.count, by: 1) {
            let status = orderArray[num].orderStatus
            
            //접수대기
            if status == TAB_ORDER_STATUS_ORDER {
                tempStatus = 0
                GlobalShareManager.shared().order_countOrder += 1
                
            } //처리중
            else if status == TAB_ORDER_STATUS_RESERVATIONWAITTING || status == TAB_ORDER_STATUS_ORDERCOMPLETE {
                tempStatus = 1
                GlobalShareManager.shared().order_countING += 1
                
            } //완료
            else if status == TAB_ORDER_STATUS_PRODUCTCOMPLETE || status == TAB_ORDER_STATUS_PICKUPDELAY || status == TAB_ORDER_STATUS_PICKUPDELAYCOMPLETE || status == TAB_ORDER_STATUS_PICKUPWAITTING {
                tempStatus = 2
                GlobalShareManager.shared().order_countComplete += 1
                
            } //취소
            else if status == TAB_ORDER_STATUS_ORDERCANCEL {
                tempStatus = 3
                GlobalShareManager.shared().order_countCancel += 1
            }
            
            if state == tempStatus {
                self.orderCount += 1
                self.orderTodayViewArray.append(orderArray[num])
            }
        }
        
        if self.typeOrderContent == TAB_ORDER_ORDERTODAY {
            CustomTableView.reloadData()
        }
    }
    
    func updateSearchData(isRefresh: Bool = false) {
        
        if isRefresh {
            GlobalShareManager.shared().orderSearchArray.removeAll()
        }
        
        for i in stride(from: 0, to: self.searchArray.count, by: 1) {
            GlobalShareManager.shared().orderSearchArray.append(self.searchArray[i])
        }
        
        orderCount = Int64(GlobalShareManager.shared().orderSearchArray.count)
        LogPrint("receiptCount : \(orderCount)")
        
        if self.typeOrderContent == TAB_ORDER_ORDERALL {
            CustomTableView.reloadData()
        }
        
    }
    
    func updateOrderToday() {
        
        self.hasNextPage = false
        
        if typeOrderContent == TAB_ORDER_ORDERALL {
            viewColorLine.lineMove(duration: 0.3, leftConstaint: tabLineLeftXPosition)
        }
        labelOrderToday.textColor = .black
        labelOrderAll.textColor = COMMON_GRAY1
        
        typeOrderContent = TAB_ORDER_ORDERTODAY
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
        
        updateData(state: self.todayCategoryState)
    }
    
    func updateOrderAll() {
        
        self.hasNextPage = true
        
        if typeOrderContent == TAB_ORDER_ORDERTODAY {
            viewColorLine.lineMove(duration: 0.3, leftConstaint: tabLineRightXPosition)
        }
        labelOrderToday.textColor = COMMON_GRAY1
        labelOrderAll.textColor = .black
        
        typeOrderContent = TAB_ORDER_ORDERALL
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERALL
        
        orderCount = Int64(GlobalShareManager.shared().orderSearchArray.count)

        CustomTableView.reloadData()
    }
    
    func getOrderToday(){
        
        isLoadingShow = true
        LoadingView.showLoading()
        
        DispatchQueue.main.async {
            NetworkManager.shared().getOrdersToday(token: self.accessToken, storeCode: self.storeCode, progress: "ALL", completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getOrdersToday")
                        
                        do {
                            GlobalShareManager.shared().orderTodayArray.removeAll()
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let jsonResult = try JSON(data: jsonData)
                            
                            let orderTodayResult = jsonResult["data"]
                            GlobalShareManager.shared().orderTodayArray = orderTodayResult.arrayValue.compactMap({orderReceiptData($0)})
                            
                            self.updateData(state: self.todayCategoryState)
                            
                            self.isLoadingShow = false
                            LoadingView.hideLoading()
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET ORDERS TODAY FAIL")
                        
                        self.isLoadingShow = false
                        LoadingView.hideLoading()
                    }
                } else {
                    LogPrint("NETWORK FAIL - getOrdersToday")
                    
                    self.isLoadingShow = false
                    LoadingView.hideLoading()
                }
            })
        }
    }
    
    func getOrderSearch(startDate:String, endDate:String, searchName: String, isRefresh: Bool = false, isSearch: Bool = true) {
        if !isSearch {
            self.isLoadingShow = false
            LoadingView.hideLoading()
            
            return
        } else {
            isLoadingShow = true
            LoadingView.showLoading()
        }
        
        let tempStartDate = startDate.components(separatedBy: ["-"]).joined()
        let tempEndDate = endDate.components(separatedBy: ["-"]).joined()
        let orderStatus = self.searchType
        
        var strCount: String = ""
        var strSize: String = ""
        
        if isRefresh {
            strCount = String(1)
            strSize = String(self.pagingSize * self.pagingCount)
        } else {
            strCount = String(self.pagingCount)
            strSize = String(self.pagingSize)
        }
        
        DispatchQueue.main.async {
            NetworkManager.shared().getOrders(token: self.accessToken, storeCode: self.storeCode, startDate: tempStartDate, endDate: tempEndDate, orderStatus: orderStatus, keyWord: searchName, pageNo: strCount, pageSize: strSize, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getOrderSearch")
                        
                        do {
                            self.searchArray.removeAll()
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let jsonResult = try JSON(data: jsonData)
                            
                            let orderSearchResult = jsonResult["data"]
                            self.searchArray = orderSearchResult.arrayValue.compactMap({orderReceiptData($0)})
                            LogPrint("searchArray size:\(self.searchArray.count)")
                            
                            if self.searchArray.count == 0 {
                                self.pagingCount -= 1
                            }
                            
                            self.updateSearchData(isRefresh: isRefresh)
                            
                            self.isLoadingShow = false
                            LoadingView.hideLoading()
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET OrderSearch FAIL")
                        
                        self.isLoadingShow = false
                        LoadingView.hideLoading()
                    }
                } else {
                    LogPrint("NETWORK FAIL - getOrderSearch")
                    
                    self.isLoadingShow = false
                    LoadingView.hideLoading()
                }
            })
        }
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.up :
                    LogPrint("UP")
                case UISwipeGestureRecognizer.Direction.down :
                    LogPrint("DOWN")
                case UISwipeGestureRecognizer.Direction.left :
                    LogPrint("LEFT")
                
                    if typeOrderContent == TAB_ORDER_ORDERTODAY {
                        setViewShadowDisable(view: topView, type: "title")
                        updateOrderAll()
                    }
                
                case UISwipeGestureRecognizer.Direction.right :
                    LogPrint("RIGHT")
                
                    if typeOrderContent == TAB_ORDER_ORDERALL {
                        setViewShadowDisable(view: topView, type: "title")
                        updateOrderToday()
                    }
                default:
                    break
            }
            
        }
        
    }
    
    @objc func callReloadOrderReceiptView(_ notification: Notification) {
        LogPrint("callReloadOrderReceiptView")
        
        initLoadView()
    }
    
    @objc func callPushOrderReceipt(_ notification: Notification) {
        LogPrint("callPushOrderReceipt")
        
        var message = ""
        var status = ""
        var popupStatus = ""
        
        if let userInfo = notification.userInfo as? [String: Any] {
            message = userInfo["message"] as? String ?? ""
            status = userInfo["orderStatus"] as? String ?? ""
        }
        
        initLoadView()
        
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
    
    @objc func callOrderWaitting(_ notification: Notification) {
        LogPrint("callOrderWaitting")
        
        todayCategoryState = TAB_ORDER_ORDERWAITING
        updateData(state: TAB_ORDER_ORDERWAITING)
    }
    
    @objc func callOrderING(_ notification: Notification) {
        LogPrint("callOrderING")
        
        todayCategoryState = TAB_ORDER_ORDERPROCESSING
        updateData(state: TAB_ORDER_ORDERPROCESSING)
    }
    
    @objc func callOrderComplete(_ notification: Notification) {
        LogPrint("callOrderComplete")
        
        todayCategoryState = TAB_ORDER_ORDERCOMPLETE
        updateData(state: TAB_ORDER_ORDERCOMPLETE)
    }
    
    @objc func callOrderCancel(_ notification: Notification) {
        LogPrint("callOrderCancel")
        
        todayCategoryState = TAB_ORDER_ORDERCANCEL
        updateData(state: TAB_ORDER_ORDERCANCEL)
    }
    
    @objc func callOrderSearch(_ notification: Notification) {
        LogPrint("callOrderSearch - \(self.storeCode)")
        
        isSearchClick = true
        
        isLoadingShow = true
        LoadingView.showLoading()
        
        let userInfo = notification.userInfo as! [String: Any]
        startDate = userInfo["startDate"] as? String ?? ""
        endDate = userInfo["endDate"] as? String ?? ""
        searchName = userInfo["searchName"] as? String ?? ""
        searchType = userInfo["searchType"] as? String ?? ""
        
        self.pagingCount = 1
        self.orderCount = 0
        
        GlobalShareManager.shared().orderSearchArray.removeAll()
        
        self.getOrderSearch(startDate: self.startDate, endDate: self.endDate, searchName: self.searchName, isSearch: isSearchClick)
    }
    
    @objc func callOrderStateChange(_ notification: Notification) {
        LogPrint("callOrderStateChange")
        
        isLoadingShow = true
        LoadingView.showLoading()
        
        let userInfo = notification.userInfo as! [String: Any]
        let category = userInfo["orderCategory"] as? Int ?? -1
        let orderId = userInfo["orderId"] as? String ?? ""
        let saleId = userInfo["saleId"] as? String ?? ""
        let productName = userInfo["productName"] as? String ?? ""
        let productAmount = userInfo["productAmount"] as? String ?? ""
        let orderStatus = userInfo["orderStatus"] as? String ?? ""
        let orderType = userInfo["orderType"] as? String ?? ""
        let cancelType = userInfo["cancelType"] as? String ?? ""
        let cancelReason = userInfo["cancelReason"] as? String ?? ""
        
        //ysh 조리시간 popup 확인필요
        if cancelType.count > 0 {
            
            NetworkManager.shared().getOrderCancel(token: self.accessToken, storeCode: self.storeCode, orderId: orderId, saleId: saleId, orderStatus: orderStatus, orderType: orderType, cancelReasonType: cancelType, cancelReason: cancelReason, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getOrderCancel")

                        do {
                            
                            self.getOrderToday()
                            self.getOrderSearch(startDate: self.startDate, endDate: self.endDate, searchName: self.searchName, isRefresh: true, isSearch: self.isSearchClick)
                            
                            //[주문취소] 아메리카노 외 1건 / 9,900원
                            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupNotificationViewController") as? PopupNotificationViewController {
                                viewController.popupType = "noti"
                                viewController.popupStatus = "new"
                                viewController.popupMessage = "popup_noti_cancel".localized() + "\(productName) / \(productAmount)" + "home_sales_amount".localized()
                                viewController.showAnim(vc: self, type: .move, position: .top, parentAddView: self.view) { }
                            }
                            
                        } catch {

                        }

                    } else {
                        LogPrint("GET getOrderCancel FAIL")
                        
                    }
                } else {
                    LogPrint("NETWORK FAIL - getOrderCancel")
                    
                }
            })
            
        } else {
            
            NetworkManager.shared().getOrderStatus(token: self.accessToken, storeCode: self.storeCode, orderId: orderId, saleId: saleId, orderStatus: orderStatus, orderType: orderType, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getOrderStatus")

                        do {
                            
                            self.getOrderToday()
                            self.getOrderSearch(startDate: self.startDate, endDate: self.endDate, searchName: self.searchName, isRefresh: true, isSearch: self.isSearchClick)
                            
                            //ysh 주문 상태 변경 - category에서 status로
                            //접수대기 -> 접수완료
                            if category == TAB_ORDER_ORDERWAITING {
                                
                                //[상품준비] 아메리카노 외 1건 / 9,900원
                                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupNotificationViewController") as? PopupNotificationViewController {
                                    viewController.popupType = "noti"
                                    viewController.popupStatus = "change"
                                    viewController.popupMessage = "popup_noti_ready".localized() + "\(productName) / \(productAmount)" + "home_sales_amount".localized()
                                    viewController.showAnim(vc: self, type: .move, position: .top, parentAddView: self.view) { }
                                }
                            }
                            //접수완료 -> 상품준비완료
                            else if category == TAB_ORDER_ORDERPROCESSING {
                                
                                //[상품준비완료] 아메리카노 외 1건 / 9,900원
                                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupNotificationViewController") as? PopupNotificationViewController {
                                    viewController.popupType = "noti"
                                    viewController.popupStatus = "change"
                                    viewController.popupMessage = "popup_noti_complete".localized() + "\(productName) / \(productAmount)" + "home_sales_amount".localized()
                                    viewController.showAnim(vc: self, type: .move, position: .top, parentAddView: self.view) { }
                                }
                            }
                            else if category == TAB_ORDER_ORDERCOMPLETE {
                                
                                //[픽업요청알림] 아메리카노 외 1건 / 9,900원
                                if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupNotificationViewController") as? PopupNotificationViewController {
                                    viewController.popupType = "noti"
                                    viewController.popupStatus = "change"
                                    viewController.popupMessage = "popup_noti_pickup".localized() + "\(productName) / \(productAmount)" + "home_sales_amount".localized()
                                    viewController.showAnim(vc: self, type: .move, position: .top, parentAddView: self.view) { }
                                }
                            }
                            
                        } catch {

                        }

                    } else {
                        LogPrint("GET getOrderStatus FAIL")
                        
                    }
                } else {
                    LogPrint("NETWORK FAIL - getOrderStatus")
                    
                }
            })
            
        }
        
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        LogPrint("refresh")
        
        if self.typeOrderContent == TAB_ORDER_ORDERTODAY {
            self.getOrderToday()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + REFRESH_DELAY_TIME_DEFAULT) {
                self.refreshControl.endRefreshing()
            }
            
        } else {
            //전체주문 탭에서 리프레쉬 기능 삭제
//            self.getOrderSearch(startDate: self.startDate, endDate: self.endDate, searchName: self.searchName, isRefresh: true, isSearch: isSearchClick)
            
        }
        
        
    }
    
    @objc func touchImageHome(sender: UITapGestureRecognizer) {
        LogPrint("touchImageHome")
        
        self.tabBarController?.selectedIndex = 0
        GlobalShareManager.shared().selectTabIndex = 0
        //badgeCount
//        badgeCount += 1
//        self.tabBarController?.tabBar.items?[1].badgeValue = String(badgeCount)
        
    }
    
    @objc func touchOrderToday(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderToday")
        
        setViewShadowDisable(view: topView, type: "title")
        
        //tableview swipe 시 tableview 초기화
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.CustomTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        updateOrderToday()
        
        initRefresh()
    }
    
    @objc func touchOrderAll(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderAll")
        
        setViewShadowDisable(view: topView, type: "title")
        
        //tableview swipe 시 tableview 초기화
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.CustomTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        updateOrderAll()
        
        initRefresh()
    }
    
    @IBAction func actionTestBtn(_ sender: Any) {
        
        //noti
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        appDelegate.postNotification(title: "[신규주문]", body: "아메리카노 외 1건 / 12,500원")
        
        //orderCount
        orderCount += 1
        
        //badgeCount
        badgeCount += 1
        self.tabBarController?.tabBar.items?[1].badgeValue = String(badgeCount)
        
        CustomTableView.reloadData()
    }
    
}


extension OrderReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LogPrint("select cell - section : \(indexPath.section) , index : \(indexPath.row)")
    }
    
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        
        if section == 0 {
            count = Int(1 + orderCount + 1)
        } else if section == 1 && isPaging && hasNextPage {
            count = 1
        }
        
        return count
    }
    
    
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //LogPrint("heightForRowAt : \(indexPath.row)")
        
        var height : CGFloat = 0.0
        
        if indexPath.row == 0 {
            if typeOrderContent == TAB_ORDER_ORDERTODAY {
                height = cellHeight[0]
            } else {
                height = cellHeight[0] + 50
            }
        } else if indexPath.row > 0 && indexPath.row == orderCount + 1 {
            if orderCount == 0 {
                height = getScreenSize().height - cellEmptyHeight
            } else {
                
                if self.typeOrderContent == TAB_ORDER_ORDERTODAY {
                    if self.todayCategoryState == TAB_ORDER_ORDERWAITING || self.todayCategoryState == TAB_ORDER_ORDERPROCESSING {
                        
                        height = cellHeight[2]
                    }
                } else {
                    height = 0
                }
            }
        } else {
            
            if typeOrderContent == TAB_ORDER_ORDERALL {     // 전체주문
                
                let orderArray = GlobalShareManager.shared().orderSearchArray
                if orderArray.count > 0 {
                    
                    let orderStatus = orderArray[indexPath.row - 1].orderStatus
                    if orderStatus == TAB_ORDER_STATUS_ORDERCANCEL {                //주문취소
                        
                        let orderType = orderArray[indexPath.row - 1].orderType
                        if orderType == TAB_ORDER_TYPE_STORE_RESERVATION
                        || orderType == TAB_ORDER_TYPE_PICKUP_RESERVATION
                        || orderType == TAB_ORDER_TYPE_STORE
                        || orderType == TAB_ORDER_TYPE_STORE_EAT {                      //예약
                            
                            cellHeight[1] = ORDER_VIEW_HEIGHT_RESERVATION_CANCEL
                        } else {                                                        //그외
                            cellHeight[1] = ORDER_VIEW_HEIGHT_ORDER_CANCEL
                        }
                        
                    } else {                                                        //접수대기, 처리중, 완료
                        
                        let orderType = orderArray[indexPath.row - 1].orderType
                        if orderType == TAB_ORDER_TYPE_STORE_RESERVATION
                        || orderType == TAB_ORDER_TYPE_PICKUP_RESERVATION
                        || orderType == TAB_ORDER_TYPE_STORE
                        || orderType == TAB_ORDER_TYPE_STORE_EAT {                      //예약
                            
                            cellHeight[1] = ORDER_VIEW_HEIGHT_RESERVATION
                        } else {                                                        //그외
                            cellHeight[1] = ORDER_VIEW_HEIGHT_ORDER
                        }
                    }
                }
                
            } else {                                        // 오늘주문
                
                let orderArray = self.orderTodayViewArray
                if orderArray.count > 0 {
                    
                    let orderStatus = orderArray[indexPath.row - 1].orderStatus
                    if orderStatus == TAB_ORDER_STATUS_ORDERCANCEL {                //주문취소
                        
                        let orderType = orderArray[indexPath.row - 1].orderType
                        if orderType == TAB_ORDER_TYPE_STORE_RESERVATION
                        || orderType == TAB_ORDER_TYPE_PICKUP_RESERVATION
                        || orderType == TAB_ORDER_TYPE_STORE
                        || orderType == TAB_ORDER_TYPE_STORE_EAT {                      //예약
                            
                            cellHeight[1] = ORDER_VIEW_HEIGHT_RESERVATION_CANCEL
                        } else {                                                        //그외
                            cellHeight[1] = ORDER_VIEW_HEIGHT_ORDER_CANCEL
                        }
                        
                    } else {                                                        //접수대기, 처리중, 완료
                        
                        let orderType = orderArray[indexPath.row - 1].orderType
                        if orderType == TAB_ORDER_TYPE_STORE_RESERVATION
                        || orderType == TAB_ORDER_TYPE_PICKUP_RESERVATION
                        || orderType == TAB_ORDER_TYPE_STORE
                        || orderType == TAB_ORDER_TYPE_STORE_EAT {                      //예약
                            
                            cellHeight[1] = ORDER_VIEW_HEIGHT_RESERVATION
                        } else {                                                        //그외
                            cellHeight[1] = ORDER_VIEW_HEIGHT_ORDER
                        }
                    }
                    
                }
            }
            
            height = cellHeight[1]
        }
        
        return height
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //LogPrint("tableView count : \(indexPath), \(indexPath.row)")
        
        if indexPath.section == 0 {
        
            if indexPath.row == 0 {
                
                if typeOrderContent == TAB_ORDER_ORDERTODAY {
                    
                    let cell = CustomTableView.dequeueReusableCell(withIdentifier: "OrderCategoryCell", for: indexPath) as! OrderCategoryCell
                    cell.initCategory(select: todayCategoryState)
                    
                    return cell
                    
                } else {
                    
                    let cell = CustomTableView.dequeueReusableCell(withIdentifier: "OrderSearchCell", for: indexPath) as! OrderSearchCell
                    
                    var searchStartDate = self.startDate
                    var searchEndDate = self.endDate
                    
                    if searchStartDate.count == 0 {
                        searchStartDate = nowDate(search:"m").startDate
                    }
                    if searchEndDate.count == 0 {
                        searchEndDate = nowDate(search:"m").endDate
                    }
                    
                    cell.setupDate(startDate: searchStartDate, endDate: searchEndDate)
                    cell.superView = self
                    return cell
                    
                }
                
            } else if indexPath.row > 0 && indexPath.row < orderCount + 1 {
                
                let cell = CustomTableView.dequeueReusableCell(withIdentifier: "OrderReceiptCell", for: indexPath) as! OrderReceiptCell
                LogPrint("\(indexPath.row - 1)")
                
                cell.superView = self
                
                //****************************************************************************************************//
                var orderTypeName = ""
                var isReservation: Bool = false
                var reservationTime = ""
                var reservationCount:Int64 = 0

                var orderViewArray = Array<orderReceiptData>()
                if typeOrderContent == TAB_ORDER_ORDERALL {     // 전체주문
                    orderViewArray = GlobalShareManager.shared().orderSearchArray
                } else {                                        // 오늘주문
                    orderViewArray = self.orderTodayViewArray
                    //ysh 접수대기, 처리중 - 오래된순으로 정렬필요시 array 뒤집어서 정렬 필요
                }
                
                if orderViewArray.count == 0 {
                    return cell
                }
                
                cell.categoryState = self.todayCategoryState
                
                let tempStatus = orderViewArray[indexPath.row - 1].orderStatus ?? ""
                let tempOrderType = orderViewArray[indexPath.row - 1].orderType ?? ""
                orderTypeName = orderViewArray[indexPath.row - 1].orderTypeName ?? ""
                isReservation = orderViewArray[indexPath.row - 1].isReservation ?? false
                reservationTime = orderViewArray[indexPath.row - 1].reservationTime ?? ""
                reservationCount = orderViewArray[indexPath.row - 1].reservationPersonCount ?? 0

                cell.labelOrderNumber.text = "order_wait_number".localized() + " \(orderViewArray[indexPath.row - 1].waitNo ?? "")"
                let receiptDate = getReceiptDate(date: orderViewArray[indexPath.row - 1].orderTime ?? "")
                cell.labelOrderDate.text = "\(receiptDate.strDate)(\(receiptDate.strWeek)) \(receiptDate.strTime)"
                cell.labelOrderProduct.text = orderViewArray[indexPath.row - 1].productName ?? ""
                
                // 상태변경을 위해 데이터 전달
                cell.orderProductName = orderViewArray[indexPath.row - 1].productName ?? ""
                cell.orderProductAmount = orderViewArray[indexPath.row - 1].saleAmount ?? 0
                cell.orderId = orderViewArray[indexPath.row - 1].orderId ?? 0
                cell.saleId = orderViewArray[indexPath.row - 1].saleId ?? 0
                cell.orderStatus = tempStatus
                cell.orderType = tempOrderType
                
                //****************************************************************************************************//
                
                let isToday = isNowToday(nowTime: orderViewArray[indexPath.row - 1].orderTime!)
                
                if tempOrderType == "03" || tempOrderType == "05" {
                    
                    cell.viewReservation.isHidden = false
                    cell.labelReservation.isHidden = false
                    
                    let reservationDate = getReceiptDate(date: orderViewArray[indexPath.row - 1].reservationTime ?? "")
                    
                    if isToday {
                        reservationTime = "view_today".localized() + " " + getReceiptDate(date: orderViewArray[indexPath.row - 1].reservationTime ?? "").strTime
                    } else {
                        reservationTime = "\(reservationDate.strDate)(\(reservationDate.strWeek)) \(reservationDate.strTime)"
                    }
                    
                    if reservationCount > 0 {
                        cell.labelReservation.text = reservationTime + " (" + String(reservationCount) + "view_people".localized() + ")" + " " + "view_reservation".localized()
                    } else {
                        cell.labelReservation.text = reservationTime + " " + "view_reservation".localized()
                    }
                    
                } else if tempOrderType == "01" || tempOrderType == "02" {
                    
                    cell.viewReservation.isHidden = false
                    cell.labelReservation.isHidden = false
                    
                    let tableName = orderViewArray[indexPath.row - 1].tableName ?? ""
                    
                    cell.labelReservation.text = "order_detail_reservation_table".localized() + " : \(tableName)"
                    
                } else {
                    
                    cell.viewReservation.isHidden = true
                    cell.labelReservation.isHidden = true
                }
                
                //****************************************************************************************************//
                
                if orderTypeName.contains("매장예약") {
                    cell.imageOrderType.image = UIImage(named:"order_reser_inside")
                    
                } else if orderTypeName.contains("포장예약") {
                    cell.imageOrderType.image = UIImage(named:"order_reser_takeout")
                    
                } else if orderTypeName.contains("매장식사") {
                    cell.imageOrderType.image = UIImage(named:"order_inside")
                    
                } else if orderTypeName.contains("포장") {
                    cell.imageOrderType.image = UIImage(named:"order_takeout")
                }
                
                //****************************************************************************************************//
                
                //접수대기
                if tempStatus == TAB_ORDER_STATUS_ORDER {
                    cell.viewCancel.isHidden = false
                    cell.labelCancel.isHidden = false
                    cell.viewConfirm.isHidden = false
                    cell.labelConfirm.isHidden = false
                    cell.viewOneButton.isHidden = true
                    cell.labelOneButton.isHidden = true
                    
                    cell.labelConfirm.text = "order_detail_button_confirm".localized()
                    cell.labelCancel.text = "order_detail_button_cancel".localized()
                    
                    cell.labelOrderType.textColor = COMMON_ORANGE
                    
                    cell.labelOrderType.text = "order_status_order".localized()
                    
                } //처리중 - 상품준비
                else if tempStatus == TAB_ORDER_STATUS_ORDERCOMPLETE {
                    cell.viewCancel.isHidden = false
                    cell.labelCancel.isHidden = false
                    cell.viewConfirm.isHidden = false
                    cell.labelConfirm.isHidden = false
                    cell.viewOneButton.isHidden = true
                    cell.labelOneButton.isHidden = true
                    
                    cell.labelConfirm.text = "order_search_complete".localized()
                    cell.labelCancel.text = "order_detail_button_cancel".localized()
                    
                    cell.labelOrderType.textColor = COMMON_ORANGE
                    
                    cell.labelOrderType.text = "order_status_order_complete".localized()
                    
                } //처리중 - 예약대기
                else if tempStatus == TAB_ORDER_STATUS_RESERVATIONWAITTING {
                    cell.viewCancel.isHidden = false
                    cell.labelCancel.isHidden = false
                    cell.viewConfirm.isHidden = false
                    cell.labelConfirm.isHidden = false
                    cell.viewOneButton.isHidden = true
                    cell.labelOneButton.isHidden = true
                    
                    cell.labelConfirm.text = "order_search_complete".localized()
                    cell.labelCancel.text = "order_detail_button_cancel".localized()
                    
                    cell.labelOrderType.textColor = COMMON_ORANGE
                    
                    cell.labelOrderType.text = "order_status_reservation".localized()
                    
                } //완료
                else if tempStatus == TAB_ORDER_STATUS_PRODUCTCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPDELAY || tempStatus == TAB_ORDER_STATUS_PICKUPDELAYCOMPLETE || tempStatus == TAB_ORDER_STATUS_PICKUPWAITTING {
                    cell.viewCancel.isHidden = true
                    cell.labelCancel.isHidden = true
                    cell.viewConfirm.isHidden = true
                    cell.labelConfirm.isHidden = true
                    cell.viewOneButton.isHidden = false
                    cell.labelOneButton.isHidden = false
                    
                    cell.labelOneButton.text = "order_detail_button_onebutton".localized()
                    
                    cell.labelOrderType.textColor = COMMON_ORANGE
                    
                    cell.labelOrderType.text = "order_status_product_complete".localized()
                    
                } //취소
                else if tempStatus == TAB_ORDER_STATUS_ORDERCANCEL {
                    cell.viewCancel.isHidden = true
                    cell.labelCancel.isHidden = true
                    cell.viewConfirm.isHidden = true
                    cell.labelConfirm.isHidden = true
                    cell.viewOneButton.isHidden = true
                    cell.labelOneButton.isHidden = true
                    
                    cell.labelOrderType.textColor = COMMON_GRAY2
                    
                    cell.labelOrderType.text = "order_status_cancel".localized()
                }
                
                //****************************************************************************************************//
                return cell
                
            } else {
                let cell = CustomTableView.dequeueReusableCell(withIdentifier: "OrderTableCommentCell", for: indexPath) as! OrderTableCommentCell
                cell.OrderCount = Int(orderCount)
                cell.initComment()
                return cell
            }
            
        } else {
            
            guard let cell = CustomTableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                return UITableViewCell()
            }
            
            cell.start()
            
            return cell
        }
    }
    
}


extension OrderReceiptViewController: UIScrollViewDelegate {

    //스크롤 방향성
    func scrollDirection(scrollView: UIScrollView) {
        let velocity: CGFloat = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if velocity < 0 {
//            LogPrint("UP")
//            isDirectionDown = false
        } else if velocity > 0 {
//            LogPrint("DOWN")
//            isDirectionDown = true
        }
    }

    //스크롤 되는 동안 호출
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LogPrint("table scrollViewDidScroll")

        scrollDirection(scrollView: scrollView)
        
        if self.orderCount == 0 {
            return
        }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        //LogPrint("1:\(offsetY),  2:\(contentHeight),  3:\(height)")
        if offsetY > 0 {
            setViewShadow(view: topView, type: "title")
        } else {
            setViewShadowDisable(view: topView, type: "title")
        }

        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            
            if isPaging == false && hasNextPage {
                
                isPaging = true // 현재 페이징이 진행 되는 것을 표시
                // Section 1을 reload하여 로딩 셀을 보여줌 (페이징 진행 중인 것을 확인할 수 있도록)
                DispatchQueue.main.async {
                    self.CustomTableView.reloadSections(IndexSet(integer: 1), with: .none)
                }
                
                // 페이징 메소드 호출
                self.paging()
            }
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


//ysh popupview call
//********** viewcontroller *********//
//if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupVariableButtonViewController") as? PopupVariableButtonViewController {
//    viewController.popupType = "estimateTime"
//    viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true,type: .fadeInOut, position: .center, parentAddView: self.view) { }
//}

//********** tableViewCell ***********//
//if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
//    viewController.popupState = self.categoryState
//    viewController.strTitle = self.labelOrderNumber.text ?? ""
//    viewController.showAnim(vc: self.superView, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.superView.view) { }
//}

//********** tabbar hidden ***********//
//self.navigationController?.setNavigationBarHidden(true, animated: false)
//self.tabBarController?.tabBar.isHidden = true

//********** windows first ***********//
//let scenes = UIApplication.shared.connectedScenes
//let windowScene = scenes.first as? UIWindowScene
//let window = windowScene?.windows.first

//********** statusBar Height ***********//
//let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//********** first view ***********//
//let firstView = window?.rootViewController

//********** view & button round corner radius ***********//
//    .layerMinXMinYCorner  .layerMaxXMinYCorner
//    .layerMinXMaxYCorner  .layerMaxXMaxYCorner
//viewOrderButton.roundCorners(cornerRadius: 4, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])


//********** productname 길이에 따라 height 변경을 위한 계산 ***********//
////글자의 size를 가져와서 (labelDot1Message.text! -> string) (labelDot1Message -> label)
//let size = labelDot1Message.text!.size(withAttributes: [NSAttributedString.Key.font : labelDot1Message.font!]).width
////label 보다 많으면 2줄로 보여주기
//let labelWidth = labelDot1Message.frame.width
//let line = labelWidth - size
//
////마이너스로 나오는것은 글자수가 레이블보다 많을경우(글자가 많을경우) = 그래서 2줄로 보여줌
//if line > 0 {
//    //LogPrint("line : 한줄")
//    constSchoolInfoViewHeight.constant = SCHOOL_ADDRESS_1LINE_BOX_HEIGHT
//} else if line < 0 {
//    //LogPrint("line : 두 줄")
//    constSchoolInfoViewHeight.constant = SCHOOL_ADDRESS_2LINE_BOX_HEIGHT
//}
