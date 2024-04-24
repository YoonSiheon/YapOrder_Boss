//
//  MainTabBarController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/10.
//

import Foundation
import UIKit

internal class MainTabBarController: UITabBarController, UINavigationBarDelegate, UITabBarControllerDelegate {
    
    var selectedTabIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.delegate = self
        self.setTabBarControllers()
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
        LogPrint("viewWillDisappear")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogPrint("viewDidLayoutSubviews")
        
        self.tabBar.frame.size.height = MAIN_TBBAR_HEIGHT + CGFloat(getHomeBarHeight().height)
        self.tabBar.frame.origin.y = view.frame.height - (MAIN_TBBAR_HEIGHT + CGFloat(getHomeBarHeight().height))
        
        if let items = tabBar.items {
            for item in items {
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: MAIN_TABBAR_INFO[getNotchIdx()][1])
            }
        }
    }
    
//    @objc func appMovedToForeground() {
//        LogPrint("appMovedToForeground")
//    }
//
//    @objc func appMovedToBackground() {
//        LogPrint("appMovedToBackground")
//    }
    
    func setTabBarControllers() {
//        CustomTabBar.appearance().tintColor = DARK_COLOR
//        CustomTabBar.appearance().layer.borderWidth = 0
//        CustomTabBar.appearance().clipsToBounds = true

        self.tabBar.unselectedItemTintColor = TAB_BAR_TITLE_COLOR_DEFAULT
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.layer.borderWidth = 1.0
        self.tabBar.layer.borderColor = TAB_BAR_BORDER_COLOR.cgColor
        self.tabBar.clipsToBounds = true
        
        MainTabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: TAB_BAR_TITLE_COLOR_DEFAULT], for: .normal)

        MainTabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: TAB_BAR_TITLE_COLOR_SELECTED], for: .selected)
        
        let tabBarViewControllers: [UIViewController] = self.viewControllers!
        var newTabBarViewControllers: [UIViewController] = []
        
        var homeNavigationView: UIViewController? = nil
        var orderReceiptNavigationView: UIViewController? = nil
        var serviceManagementNavigationView: UIViewController? = nil
        var salesStatisticsNavigationView: UIViewController? = nil
        var moreMenuNavigationView: UIViewController? = nil
        
        for vc in tabBarViewControllers {
            
            if vc.restorationIdentifier!.contains(NAVIGATION_CONTROLLER_HOME) {
                homeNavigationView = vc
                homeNavigationView?.tabBarItem.title = "navigation_title_home".localized()
            }
            
            if vc.restorationIdentifier!.contains(NAVIGATION_CONTROLLER_ORDERRECEIPT) {
                orderReceiptNavigationView = vc
                orderReceiptNavigationView?.tabBarItem.title = "navigation_title_orderReceipt".localized()
            }
            
            if vc.restorationIdentifier!.contains(NAVIGATION_CONTROLLER_SERVICEMANAGEMENT) {
                serviceManagementNavigationView = vc
                serviceManagementNavigationView?.tabBarItem.title = "navigation_title_serviceManagement".localized()
            }
            
            if vc.restorationIdentifier!.contains(NAVIGATION_CONTROLLER_SALESSTATISTICS) {
                salesStatisticsNavigationView = vc
                salesStatisticsNavigationView?.tabBarItem.title = "navigation_title_salesStatistics".localized()
            }
            
            if vc.restorationIdentifier!.contains(NAVIGATION_CONTROLLER_MOREMENU) {
                moreMenuNavigationView = vc
                moreMenuNavigationView?.tabBarItem.title = "navigation_title_moreMenu".localized()
            }
        }
        
        if homeNavigationView == nil { // 재활용 하려는 뷰가 없다면 새로 생성
            homeNavigationView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_HOME)
            homeNavigationView?.tabBarItem.title = "navigation_title_home".localized()
        }
        
        if orderReceiptNavigationView == nil {
            orderReceiptNavigationView = UIStoryboard(name: "OrderReceipt", bundle: nil).instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_ORDERRECEIPT)
            orderReceiptNavigationView?.tabBarItem.title = "navigation_title_orderReceipt".localized()
        }
        
        if serviceManagementNavigationView == nil {
            serviceManagementNavigationView = UIStoryboard(name: "ServiceManagement", bundle: nil).instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_SERVICEMANAGEMENT)
            serviceManagementNavigationView?.tabBarItem.title = "navigation_title_serviceManagement".localized()
        }
        
        if salesStatisticsNavigationView == nil {
            salesStatisticsNavigationView = UIStoryboard(name: "SalesStatistics", bundle: nil).instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_SALESSTATISTICS)
            salesStatisticsNavigationView?.tabBarItem.title = "navigation_title_salesStatistics".localized()
        }
        
        if moreMenuNavigationView == nil {
            moreMenuNavigationView = UIStoryboard(name: "MoreMenu", bundle: nil).instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_MOREMENU)
            moreMenuNavigationView?.tabBarItem.title = "navigation_title_moreMenu".localized()
        }
        
        newTabBarViewControllers.append(homeNavigationView!)
        newTabBarViewControllers.append(orderReceiptNavigationView!)
        newTabBarViewControllers.append(serviceManagementNavigationView!)
        newTabBarViewControllers.append(salesStatisticsNavigationView!)
        newTabBarViewControllers.append(moreMenuNavigationView!)
        self.setViewControllers(newTabBarViewControllers, animated: false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        LogPrint("tabBarController")
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        LogPrint("tabBarController - didSelect")
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        LogPrint("MAIN TAB BAR Selected item : \(item.tag)")
        
        self.selectedTabIndex = GlobalShareManager.shared().selectTabIndex
        
        if item.tag == TAB_IDX_HOME {
            
            if item.tag == self.selectedTabIndex {
                NotificationCenter.default.post(name: NSNotification.Name("callReloadHomeView"), object: nil, userInfo: nil)
            }
        } else if item.tag == TAB_IDX_ORDERRECEIPT {
            
            if item.tag == self.selectedTabIndex {
                NotificationCenter.default.post(name: NSNotification.Name("callReloadOrderReceiptView"), object: nil, userInfo: nil)
            }
        } else if item.tag == TAB_IDX_SERVICEMANAGEMENT {
            
            if item.tag == self.selectedTabIndex {
                NotificationCenter.default.post(name: NSNotification.Name("callReloadManagementView"), object: nil, userInfo: nil)
            }
        } else if item.tag == TAB_IDX_SALESSTATISTICS {
            
            if item.tag == self.selectedTabIndex {
                NotificationCenter.default.post(name: NSNotification.Name("callReloadSalesStatisticsView"), object: nil, userInfo: nil)
            }
        } else if item.tag == TAB_IDX_MOREMENU {
            
            if item.tag == self.selectedTabIndex {
                NotificationCenter.default.post(name: NSNotification.Name("callReloadMoreMenuView"), object: nil, userInfo: nil)
            }
        }
        
        self.selectedTabIndex = item.tag
        GlobalShareManager.shared().selectTabIndex = item.tag
    }
    
}
