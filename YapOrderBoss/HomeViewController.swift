//
//  ViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/06.
//

import UIKit
import WebKit
import ChartProgressBar
import SwiftyJSON

class HomeViewController: UIViewController {
    
    @IBOutlet weak var labelStoreName: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    
    //***************************************************************//
    
    @IBOutlet weak var viewCategory: UIView!
    
    @IBOutlet weak var labelSwitchTitle: UILabel!
    @IBOutlet weak var labelSwitchDescription: UILabel!
    @IBOutlet weak var switchSalesClosed: UISwitch!
    
    @IBOutlet weak var labelOrderWaitingCount: UILabel!
    @IBOutlet weak var labelOrderWaitingTitle: UILabel!
    @IBOutlet weak var viewOrderWaiting: UIView!
    
    @IBOutlet weak var labelProcessingCount: UILabel!
    @IBOutlet weak var labelProcessingTitle: UILabel!
    @IBOutlet weak var viewProcessing: UIView!
    
    @IBOutlet weak var labelCompleteCount: UILabel!
    @IBOutlet weak var labelCompleteTitle: UILabel!
    @IBOutlet weak var viewComplete: UIView!
    
    @IBOutlet weak var labelCancelCount: UILabel!
    @IBOutlet weak var labelCancelTitle: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    
    @IBOutlet weak var viewOrderButton: UIView!
    @IBOutlet weak var labelViewOrderButton: UILabel!
    
    @IBOutlet weak var viewButtonCategory: UIView!
    
    @IBOutlet weak var viewTabOpenningHour: UIView!
    @IBOutlet weak var labelTabOpenningHour: UILabel!
    @IBOutlet weak var viewTabManagement: UIView!
    @IBOutlet weak var labelTabManagement: UILabel!
    @IBOutlet weak var viewTabNotice: UIView!
    @IBOutlet weak var labelTabNotice: UILabel!
    @IBOutlet weak var viewTabQuestion: UIView!
    @IBOutlet weak var labelTabQuestion: UILabel!
    
    //***************************************************************//
    
    @IBOutlet weak var labelRealSalesTitle: UILabel!
    @IBOutlet weak var labelTodayDate: UILabel!
    @IBOutlet weak var labelTodaySales: UILabel!
    @IBOutlet weak var labelYesterdatSlaes: UILabel!
    @IBOutlet weak var labelLastWeekSales: UILabel!
    @IBOutlet weak var viewDetailSalesButton: UIView!
    @IBOutlet weak var labelDetailSalesTitle: UILabel!
    
    //***************************************************************//
    
    @IBOutlet weak var labelWeeklySalesTitle: UILabel!
    @IBOutlet weak var viewLastWeekButton: UIView!
    @IBOutlet weak var labelLastWeekButtonTitle: UILabel!
    @IBOutlet weak var viewThisWeekButton: UIView!
    @IBOutlet weak var labelThisWeekButtonTitle: UILabel!
    @IBOutlet weak var viewSalesDate: UILabel!
    @IBOutlet weak var viewSalesGraph: ChartProgressBar!
    @IBOutlet weak var viewDetailWeeklySalesButton: UIView!
    @IBOutlet weak var labelDetailWeeklySalesTitle: UILabel!
    
    @IBOutlet weak var viewGraph4: UIView!
    @IBOutlet weak var bar4: UIProgressView!
    @IBOutlet weak var labelGraph4: UILabel!
    
    @IBOutlet weak var viewGraph5: UIView!
    @IBOutlet weak var bar5: UIProgressView!
    @IBOutlet weak var labelGraph5: UILabel!
    
    @IBOutlet weak var viewGraph6: UIView!
    @IBOutlet weak var bar6: UIProgressView!
    @IBOutlet weak var labelGraph6: UILabel!
    
    @IBOutlet weak var viewGraph7: UIView!
    @IBOutlet weak var bar7: UIProgressView!
    @IBOutlet weak var labelGraph7: UILabel!
    
    @IBOutlet weak var viewGraph3: UIView!
    @IBOutlet weak var bar3: UIProgressView!
    @IBOutlet weak var labelGraph3: UILabel!
    
    @IBOutlet weak var viewGraph2: UIView!
    @IBOutlet weak var bar2: UIProgressView!
    @IBOutlet weak var labelGraph2: UILabel!
    
    @IBOutlet weak var viewGraph1: UIView!
    @IBOutlet weak var bar1: UIProgressView!
    @IBOutlet weak var labelGraph1: UILabel!
    
    @IBOutlet weak var labelWeekDay: UILabel!
    @IBOutlet weak var labelWeekAmount: UILabel!
    
    @IBOutlet weak var imageBigBalloon: UIImageView!
    @IBOutlet weak var imageSmallBalloon: UIImageView!
    @IBOutlet weak var labelBalloonAmount: UILabel!
    
    @IBOutlet weak var constraintBigBalloonX: NSLayoutConstraint!
    @IBOutlet weak var constraintSmallBalloonX: NSLayoutConstraint!
    
    //***************************************************************//
    
    @IBOutlet weak var labelFavoriteMenuTitle: UILabel!
    @IBOutlet weak var labelFavoriteNumber1: UILabel!
    @IBOutlet weak var labelFavoriteNumber1Menu: UILabel!
    @IBOutlet weak var labelFavoriteNumber1Price: UILabel!
    @IBOutlet weak var labelFavoriteNumber1Count: UILabel!
    
    @IBOutlet weak var labelFavoriteNumber2: UILabel!
    @IBOutlet weak var labelFavoriteNumber2Menu: UILabel!
    @IBOutlet weak var labelFavoriteNumber2Price: UILabel!
    @IBOutlet weak var labelFavoriteNumber2Count: UILabel!
    
    @IBOutlet weak var labelFavoriteNumber3: UILabel!
    @IBOutlet weak var labelFavoriteNumber3Menu: UILabel!
    @IBOutlet weak var labelFavoriteNumber3Price: UILabel!
    @IBOutlet weak var labelFavoriteNumber3Count: UILabel!
    
    @IBOutlet weak var labelFavoriteNumber4: UILabel!
    @IBOutlet weak var labelFavoriteNumber4Menu: UILabel!
    @IBOutlet weak var labelFavoriteNumber4Price: UILabel!
    @IBOutlet weak var labelFavoriteNumber4Count: UILabel!
    
    @IBOutlet weak var labelFavoriteNumber5: UILabel!
    @IBOutlet weak var labelFavoriteNumber5Menu: UILabel!
    @IBOutlet weak var labelFavoriteNumber5Price: UILabel!
    @IBOutlet weak var labelFavoriteNumber5Count: UILabel!
    
    @IBOutlet weak var labelFavoriteNone: UILabel!
    
    //***************************************************************//
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var graphViewHeight: NSLayoutConstraint!
    @IBOutlet weak var graphBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var graphHeight: NSLayoutConstraint!
    
    // FAVORITE_HEIGHT [349, 447]
    @IBOutlet weak var favoriteViewHeight: NSLayoutConstraint!
    
    //***************************************************************//
    
    @IBOutlet weak var scView: UIScrollView!
    
    var heightScrollViewHeight: CGFloat = 0
    
    var accessToken: String = ""
    var storeCode: String = ""
    var pushId: Int64 = 0
    var posNo: String = ""
    
    //0:월 ~ 6:일
    var daySelect: Int = 0
    var dayAmount: Int = 0
    
    //0:지난주, 1:이번주
    var weekSelect: Int = 0
    
    var isLoadingShow: Bool = false
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //***************************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //**************************************************************************************************//
        
        let scrollHeight: CGFloat = 1092
        let statusBarHeight = getStatusBarHeight()
        let homeBarHeight = getHomeBarHeight()
        
        let nGraphBoxHeight = CGFloat(220)
        
        let bigview1: CGFloat = getScreenSize().height > 1000 ? 2 : 1
        let bigview2: CGFloat = getScreenSize().height > 1000 ? nGraphBoxHeight/2 + 8 : 0
        
//        LogPrint("width : \(getScreenSize().width)")
//        LogPrint("height : \(getScreenSize().height)")
//        LogPrint("statusBar : \(statusBarHeight)")
//        LogPrint("homeBarHeight : \(homeBarHeight)")
        
        
        //graph 가 그려지는 view
        graphBoxHeight.constant = nGraphBoxHeight * bigview1
        
        
        //greaphBar 의 높이
        let nGraphBarHeight = (nGraphBoxHeight - 1) * bigview1 * 0.8
        graphHeight.constant = nGraphBarHeight
        
        
        //주간 매출을 나타내고 있는 view
        let nGraphViewHeight = (nGraphBoxHeight * 2) + bigview2
        graphViewHeight.constant = nGraphViewHeight
        
        
        // 화면에서 scroll의 높이 (실제 화면높이에서 고정영역을 빼면 scroll의 높이)
        // 812 - 138(74+64) - 24(20) - 20(0)
        let temp1 = Int(getScreenSize().height) - 138 - statusBarHeight.height - homeBarHeight.height
//        LogPrint("temp1 : \(temp1)")
        
        
        // scroll 전체 높이에서 화면의 scroll 높이를 빼서 -> 추가되는 scroll높이
        // 1092(373+272+447) + 440 - temp1 - 1
        let totalScroll = round(scrollHeight + nGraphViewHeight - CGFloat(temp1) + 1)
//        LogPrint("totalScroll : \(totalScroll)")
        
        heightScrollViewHeight = totalScroll
        scrollViewHeight.constant = totalScroll
        
        // 최초 탭 선택 index 지정
        GlobalShareManager.shared().selectTabIndex = 0
        
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
        //**************************************************************************************************//
        
        defaultInit()
        chartsInit()
        
//        networkInit()
//        getStore()
//        getCookInfo()
//        getCancelReason()
        
        checkAppNoti()
        
        //**************************************************************************************************//
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callRemoveObserver(_:)), name: NSNotification.Name("callRemoveObserver"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReloadHomeView(_:)), name: NSNotification.Name("callReloadHomeView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSalesStop(_:)), name: NSNotification.Name("callSalesStop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPushHome(_:)), name: NSNotification.Name("callPushHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSetNoti(_:)), name: NSNotification.Name("callSetNoti"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        accessToken = GlobalShareManager.shared().getLocalData(GLOBAL_ACCESSTOKEN) as? String ?? ""
        storeCode = GlobalShareManager.shared().getLocalData(GLOBAL_STORE_CODE) as? String ?? ""
        pushId = GlobalShareManager.shared().getLocalData(GLOBAL_PUSHID) as? Int64 ?? 0
        posNo = GlobalShareManager.shared().getLocalData(GLOBAL_POSNO) as? String ?? ""
        
        networkInit()
        getStore()
        getCookInfo()
        getCancelReason()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
        
        if isLoadingShow {
            DispatchQueue.main.asyncAfter(deadline: .now() + LOADING_DELAY_DEFAULT) {
                self.isLoadingShow = false
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
            }
        }
        
        if GlobalShareManager.shared().isMoveToOrder == true {
            
            self.tabBarController?.selectedIndex = 1
            GlobalShareManager.shared().selectTabIndex = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func callRemoveObserver(_ notification: Notification) {
        LogPrint("callRemoveObserver - HomeViewController")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callRemoveObserver"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToForeground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("appMovedToBackground"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callReloadHomeView"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callSalesStop"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callPushHome"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("callSetNoti"), object: nil)
    }
    
    @objc func appMovedToForeground() {
        LogPrint("appMovedToForeground")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if GlobalShareManager.shared().selectTabIndex == 0 {
            LogPrint("tabIndex 0 reload")
            
            networkInit()
            getStore()
            getCookInfo()
            getCancelReason()
            
            checkAppNoti()
            
        } else if GlobalShareManager.shared().selectTabIndex == 1 {
            
            self.tabBarController?.selectedIndex = 1
            GlobalShareManager.shared().selectTabIndex = 1
        }
        
    }
    
    @objc func appMovedToBackground() {
        LogPrint("appMovedToBackground")
    }
    
    func defaultInit() {
        
        scView.delegate = self
        
        labelStoreName.text = "home_store_default_title".localized()
        
        setViewShadow(view: viewCategory, type: "home", height: 10)
        
        setViewShadow(view: viewButtonCategory, type: "home")
        
        labelSwitchTitle.text = "home_storestop_title".localized()
        if self.switchSalesClosed.isOn {
            labelSwitchDescription.text = "home_storestop_on".localized()
        } else {
            labelSwitchDescription.text = "home_storestop_off".localized()
        }
        labelOrderWaitingTitle.text = "home_count_order".localized()
        labelProcessingTitle.text = "home_count_processing".localized()
        labelCompleteTitle.text = "home_count_complete".localized()
        labelCancelTitle.text = "home_count_cancel".localized()
        labelViewOrderButton.text = "action_order_receipt".localized()
        
        labelTabOpenningHour.text = "home_tab_opening".localized()
        labelTabManagement.text = "home_tab_management".localized()
        labelTabNotice.text = "home_tab_notice".localized()
        labelTabQuestion.text = "home_tab_question".localized()
        
        labelRealSalesTitle.text = "home_realsales_title".localized()
        
        labelTodayDate.text = "view_today".localized() + " " + nowDate(type: "4") + " " + nowWeekday().strDay
        labelDetailSalesTitle.text = "action_detail".localized()
        
        labelWeeklySalesTitle.text = "home_weeklysales_title".localized()
        labelDetailWeeklySalesTitle.text = "action_detail".localized()
        viewSalesDate.text = nowDate(type: "-7") + " - " + nowDate(type: "8")
        
        labelFavoriteMenuTitle.text = "home_favorite_title".localized()
        
        viewOrderButton.roundCorners(cornerRadius: 8, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
//        viewButtonCategory.roundCorners(cornerRadius: 8, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        viewOrderButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderReceipt)))
        viewDetailSalesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchDetailSales)))
        viewDetailWeeklySalesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchDetailWeeklySales)))
        
        viewOrderWaiting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderWaiting)))
        viewProcessing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderProcessing)))
        viewComplete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderComplete)))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderCancel)))
        
        viewLastWeekButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchLastWeek)))
        viewThisWeekButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchThisWeek)))
        
        viewTabOpenningHour.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTabOpenningHour)))
        viewTabManagement.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTabManagement)))
        viewTabNotice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTabNotice)))
        viewTabQuestion.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchTabQuestion)))
        
        //***************************************************************************************************************************//
        
        weekSelect = 0
        
        let today = getDayOfWeek()
        if today == "월" {
            daySelect = 0
        } else if today == "화" {
            daySelect = 1
        } else if today == "수" {
            daySelect = 2
        } else if today == "목" {
            daySelect = 3
        } else if today == "금" {
            daySelect = 4
        } else if today == "토" {
            daySelect = 5
        } else if today == "일" {
            daySelect = 6
        }
        
        labelWeekDay.isHidden = true
        labelWeekAmount.isHidden = true
    }
    
    func networkInit() {
        
        isLoadingShow = true
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        self.getHomeData()
    }
    
    func chartsInit() {
        
        let rotate: CGFloat = -0.5
        let corner: CGFloat = 6
        
        bar4.translatesAutoresizingMaskIntoConstraints = false
        bar4.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar4.layer.cornerRadius = corner
        bar4.clipsToBounds = true
        bar4.layer.sublayers![1].cornerRadius = corner
        bar4.subviews[1].clipsToBounds = true
        bar4.setProgress(0.01, animated: false)
        
        bar5.translatesAutoresizingMaskIntoConstraints = false
        bar5.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar5.layer.cornerRadius = corner
        bar5.clipsToBounds = true
        bar5.layer.sublayers![1].cornerRadius = corner
        bar5.subviews[1].clipsToBounds = true
        bar5.setProgress(0.01, animated: false)
        
        bar6.translatesAutoresizingMaskIntoConstraints = false
        bar6.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar6.layer.cornerRadius = corner
        bar6.clipsToBounds = true
        bar6.layer.sublayers![1].cornerRadius = corner
        bar6.subviews[1].clipsToBounds = true
        bar6.setProgress(0.01, animated: false)
        
        bar7.translatesAutoresizingMaskIntoConstraints = false
        bar7.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar7.layer.cornerRadius = corner
        bar7.clipsToBounds = true
        bar7.layer.sublayers![1].cornerRadius = corner
        bar7.subviews[1].clipsToBounds = true
        bar7.setProgress(0.01, animated: false)
        
        bar3.translatesAutoresizingMaskIntoConstraints = false
        bar3.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar3.layer.cornerRadius = corner
        bar3.clipsToBounds = true
        bar3.layer.sublayers![1].cornerRadius = corner
        bar3.subviews[1].clipsToBounds = true
        bar3.setProgress(0.01, animated: false)
        
        bar2.translatesAutoresizingMaskIntoConstraints = false
        bar2.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar2.layer.cornerRadius = corner
        bar2.clipsToBounds = true
        bar2.layer.sublayers![1].cornerRadius = corner
        bar2.layer.sublayers![0].cornerRadius = corner
        bar2.subviews[1].clipsToBounds = true
        bar2.setProgress(0.01, animated: false)
        
        bar1.translatesAutoresizingMaskIntoConstraints = false
        bar1.transform = CGAffineTransform(rotationAngle: .pi * rotate)
        bar1.layer.cornerRadius = corner
        bar1.clipsToBounds = true
        bar1.layer.sublayers![1].cornerRadius = corner
        bar1.layer.sublayers![0].cornerRadius = corner
        bar1.subviews[1].clipsToBounds = true
        bar1.setProgress(0.01, animated: false)
        
        viewGraph4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph4)))
        viewGraph5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph5)))
        viewGraph6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph6)))
        viewGraph7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph7)))
        viewGraph3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph3)))
        viewGraph2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph2)))
        viewGraph1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph1)))
        
        bar4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph4)))
        bar5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph5)))
        bar6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph6)))
        bar7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph7)))
        bar3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph3)))
        bar2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph2)))
        bar1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchGraph1)))
       
    }
    
    //balloon type : 10=Big, 20=Small
    func changeWeekDay(balloon: Int, select: Int, graphValue: [Float]) {
        
        imageBigBalloon.translatesAutoresizingMaskIntoConstraints = false
        imageSmallBalloon.translatesAutoresizingMaskIntoConstraints = false
        
        let graphViewWidth = viewGraph4.layer.frame.width
        var tempBalloon: Int = 0
        
        labelGraph4.textColor = COMMON_GRAY1
        labelGraph4.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph5.textColor = COMMON_GRAY1
        labelGraph5.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph6.textColor = COMMON_GRAY1
        labelGraph6.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph7.textColor = COMMON_GRAY1
        labelGraph7.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph3.textColor = COMMON_GRAY1
        labelGraph3.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph2.textColor = COMMON_GRAY1
        labelGraph2.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        labelGraph1.textColor = COMMON_GRAY1
        labelGraph1.font = UIFont(name:"Roboto-Regular", size:CGFloat(13))
        
        bar4.progressTintColor = COMMON_GRAY4
        bar5.progressTintColor = COMMON_GRAY4
        bar6.progressTintColor = COMMON_GRAY4
        bar7.progressTintColor = COMMON_GRAY4
        bar3.progressTintColor = COMMON_GRAY4
        bar2.progressTintColor = COMMON_GRAY4
        bar1.progressTintColor = COMMON_GRAY4
        
        var strDay = ""
        
        if weekSelect == 0 {
            strDay = "home_weeklysales_lastweek".localized()
        } else if weekSelect == 1 {
            strDay = "home_weeklysales_thisweek".localized()
        }
        
        if select == 0 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[1])")
            
            bar1.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * -3 + 17
            constraintSmallBalloonX.constant = graphViewWidth * -3 + 17
            
            labelGraph1.textColor = COMMON_BLACK
            labelGraph1.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_mon".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 2
            
        } else if select == 1 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[2])")
            
            bar2.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * -2 + 17
            constraintSmallBalloonX.constant = graphViewWidth * -2 + 17
            
            labelGraph2.textColor = COMMON_BLACK
            labelGraph2.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_tue".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 2
            
        } else if select == 2 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[3])")
            
            bar3.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * -1
            constraintSmallBalloonX.constant = graphViewWidth * -1
            
            labelGraph3.textColor = COMMON_BLACK
            labelGraph3.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_wed".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 1
            
        } else if select == 3 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[4])")
            
            bar4.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = 0
            constraintSmallBalloonX.constant = 0
            
            labelGraph4.textColor = COMMON_BLACK
            labelGraph4.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_thu".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 1
            
        } else if select == 4 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[5])")
            
            bar5.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * 1
            constraintSmallBalloonX.constant = graphViewWidth * 1
            
            labelGraph5.textColor = COMMON_BLACK
            labelGraph5.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_fri".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 1
            
        } else if select == 5 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[6])")
            
            bar6.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * 2 - 19
            constraintSmallBalloonX.constant = graphViewWidth * 2 - 19
            
            labelGraph6.textColor = COMMON_BLACK
            labelGraph6.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_sta".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 3
            
        } else if select == 6 {
            
            LogPrint("changeWeekDay - select:\(select), value:\(graphValue[0])")
            
            bar7.progressTintColor = COMMON_ORANGE
            
            constraintBigBalloonX.constant = graphViewWidth * 3 - 19
            constraintSmallBalloonX.constant = graphViewWidth * 3 - 19
            
            labelGraph7.textColor = COMMON_BLACK
            labelGraph7.font = UIFont(name:"Roboto-Bold", size:CGFloat(13))
            
            strDay += " " + "home_weeklysales_sun".localized() + "home_weeklysales_day".localized()
            
            tempBalloon = 3
        }
        
        tempBalloon += balloon
        //balloon type : 11=Center Big, 21=Center Small, 12=left Big, 22=left Small, 13=right Big, 23=right Small
        if tempBalloon == 11 {
            imageBigBalloon.isHidden = false
            imageSmallBalloon.isHidden = true
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_center")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_center")
        } else if tempBalloon == 12 {
            imageBigBalloon.isHidden = false
            imageSmallBalloon.isHidden = true
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_left")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_left")
        } else if tempBalloon == 13 {
            imageBigBalloon.isHidden = false
            imageSmallBalloon.isHidden = true
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_right")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_right")
        } else if tempBalloon == 21 {
            imageBigBalloon.isHidden = true
            imageSmallBalloon.isHidden = false
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_center")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_center")
        } else if tempBalloon == 22 {
            imageBigBalloon.isHidden = true
            imageSmallBalloon.isHidden = false
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_left")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_left")
        } else if tempBalloon == 23 {
            imageBigBalloon.isHidden = true
            imageSmallBalloon.isHidden = false
            
            imageBigBalloon.image = UIImage(named: "graph_big_balloon_right")
            imageSmallBalloon.image = UIImage(named: "graph_small_balloon_right")
        }
        
        labelWeekDay.text = strDay
    }
    
    func checkAppNoti() {
        
        let deviceAlert = GlobalShareManager.shared().getLocalData(GLOBAL_DEVICE_ALERT) as? String ?? ""
        if deviceAlert == GLOBAL_FALSE {

            if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationPermissionViewController") as? NotificationPermissionViewController {
                viewController.modalPresentationStyle = .overFullScreen
                viewController.popupType = "deviceNoti"

                self.present(viewController, animated: false, completion: nil)
            }
            
        } else {
            
            let configAlert = GlobalShareManager.shared().getLocalData(GLOBAL_CONFIG_ALERT) as? String ?? ""
            if configAlert == GLOBAL_FALSE {
                if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationPermissionViewController") as? NotificationPermissionViewController {
                    viewController.modalPresentationStyle = .overFullScreen
                    viewController.popupType = "configAlert"
                    
                    self.present(viewController, animated: false, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func switchSalesClosed(_ sender: Any) {
        
        if self.switchSalesClosed.isOn {
            
            switchSalesClosed.setOn(false, animated: true)
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "Popup2ButtonViewController") as? Popup2ButtonViewController {
                viewController.popupCategory = POPUP_STATE_SALES_CLOSE
                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
            }
            
        } else {
            
            getSalesStop(bizStop: "N")
        }
        
    }
    
    @objc func callReloadHomeView(_ notification: Notification) {
        LogPrint("callReloadHomeView")
        
        networkInit()
    }
    
    @objc func callSalesStop(_ notification: Notification) {
        LogPrint("callSalesStop")
        
        let userInfo = notification.userInfo as! [String: Any]
        let bizStop = userInfo["bizStop"] as? String ?? "N"
        
        if bizStop == "Y" {
            getSalesStop(bizStop: bizStop)
        }
        
    }
    
    @objc func callPushHome(_ notification: Notification) {
        LogPrint("callPushHome")
        
        var message = ""
        var status = ""
        var popupStatus = ""
        
        if let userInfo = notification.userInfo as? [String: Any] {
            message = userInfo["message"] as? String ?? ""
            status = userInfo["orderStatus"] as? String ?? ""
        }
        
        networkInit()
        
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
    
    @objc func callSetNoti(_ notification: Notification) {
        LogPrint("callSetNoti")
        
        let userInfo = notification.userInfo as! [String: Any]
        let popupType = userInfo["popupType"] as? String ?? ""
        
        if popupType == "deviceNoti" {
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        } else if popupType == "configAlert" {
            
            GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_MORE_NOTI
            self.tabBarController?.selectedIndex = 4
            GlobalShareManager.shared().selectTabIndex = 4
        }
        
    }
    
    @objc func touchOrderReceipt(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderReceipt")
        
        self.tabBarController?.selectedIndex = 1
        GlobalShareManager.shared().selectTabIndex = 1
    }
    
    @objc func touchOrderWaiting(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderWaiting")
        
        GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERWAITING
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
        self.tabBarController?.selectedIndex = 1
        GlobalShareManager.shared().selectTabIndex = 1
    }
    
    @objc func touchOrderProcessing(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderProcessing")
        
        GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERPROCESSING
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
        self.tabBarController?.selectedIndex = 1
        GlobalShareManager.shared().selectTabIndex = 1
    }
    
    @objc func touchOrderComplete(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderComplete")
        
        GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERCOMPLETE
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
        self.tabBarController?.selectedIndex = 1
        GlobalShareManager.shared().selectTabIndex = 1
    }
    
    @objc func touchOrderCancel(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderCancel")
        
        GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERCANCEL
        GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
        self.tabBarController?.selectedIndex = 1
        GlobalShareManager.shared().selectTabIndex = 1
    }
    
    @objc func touchTabOpenningHour(sender: UITapGestureRecognizer) {
        LogPrint("touchTabOpenningHour")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_MORE_TIME
        self.tabBarController?.selectedIndex = 4
        GlobalShareManager.shared().selectTabIndex = 4
    }
    
    @objc func touchTabManagement(sender: UITapGestureRecognizer) {
        LogPrint("touchTabManagement")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_SERVICEMANAGEMENT_OUT
        self.tabBarController?.selectedIndex = 2
        GlobalShareManager.shared().selectTabIndex = 2
    }
    
    @objc func touchTabNotice(sender: UITapGestureRecognizer) {
        LogPrint("touchTabNotice")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_MORE_NOTICE
        self.tabBarController?.selectedIndex = 4
        GlobalShareManager.shared().selectTabIndex = 4
    }
    
    @objc func touchTabQuestion(sender: UITapGestureRecognizer) {
        LogPrint("touchTabQuestion")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_MORE_INQUIRY
        self.tabBarController?.selectedIndex = 4
        GlobalShareManager.shared().selectTabIndex = 4
    }
    
    @objc func touchDetailSales(sender: UITapGestureRecognizer) {
        LogPrint("touchDetailSales")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_SALESSTATISTICS
        self.tabBarController?.selectedIndex = 3
        GlobalShareManager.shared().selectTabIndex = 3
    }
    
    @objc func touchDetailWeeklySales(sender: UITapGestureRecognizer) {
        LogPrint("touchDetailWeeklySales")
        
        GlobalShareManager.shared().move_URL = NetworkManager.shared().getFrontURL() + URL_SALESSTATISTICS
        self.tabBarController?.selectedIndex = 3
        GlobalShareManager.shared().selectTabIndex = 3
    }
    
    @objc func touchLastWeek(sender: UITapGestureRecognizer) {
        LogPrint("touchLastWeek")
        
        weekSelect = 0
        
        viewLastWeekButton.backgroundColor = COMMON_BLACK
        labelLastWeekButtonTitle.textColor = COMMON_WHITE
        
        viewThisWeekButton.backgroundColor = COMMON_WHITE
        labelThisWeekButtonTitle.textColor = COMMON_BLACK
        
        updateGraphData(graphAni: true, weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchThisWeek(sender: UITapGestureRecognizer) {
        LogPrint("touchThisWeek")
        
        weekSelect = 1
        
        viewLastWeekButton.backgroundColor = COMMON_WHITE
        labelLastWeekButtonTitle.textColor = COMMON_BLACK
        
        viewThisWeekButton.backgroundColor = COMMON_BLACK
        labelThisWeekButtonTitle.textColor = COMMON_WHITE
        
        updateGraphData(graphAni: true, weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph4(sender: UITapGestureRecognizer) { // 목
        LogPrint("touchGraph4")
        
        daySelect = 3
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph5(sender: UITapGestureRecognizer) { // 금
        LogPrint("touchGraph5")
        
        daySelect = 4
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph6(sender: UITapGestureRecognizer) { // 토
        LogPrint("touchGraph6")
        
        daySelect = 5
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph7(sender: UITapGestureRecognizer) { // 일
        LogPrint("touchGraph7")
        
        daySelect = 6
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph3(sender: UITapGestureRecognizer) { // 수
        LogPrint("touchGraph3")
        
        daySelect = 2
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph2(sender: UITapGestureRecognizer) { // 화
        LogPrint("touchGraph2")
        
        daySelect = 1
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
    @objc func touchGraph1(sender: UITapGestureRecognizer) { // 월
        LogPrint("touchGraph1")
        
        daySelect = 0
        updateGraphData(weekSelect: weekSelect, daySelect: daySelect)
    }
    
}

extension HomeViewController: ChartProgressBarDelegate {
    
    func ChartProgressBar(_ chartProgressBar: ChartProgressBar, didSelectRowAt rowIndex: Int) {
        LogPrint(rowIndex)
    }
}

extension HomeViewController: UIScrollViewDelegate {

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
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        //LogPrint("1:\(offsetY),  2:\(contentHeight),  3:\(height)")
        if offsetY > 0 {
            setViewShadow(view: viewTitle, type: "title")
        } else {
            setViewShadowDisable(view: viewTitle, type: "title")
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
