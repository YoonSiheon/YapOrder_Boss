//
//  AppDelegate.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/06.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogPrint("didFinishLaunchingWithOptions")
        
        //파이어베이스 설정
        FirebaseApp.configure()
        //Mark : firebase 대리자 수신
        Messaging.messaging().delegate = self
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow, Error in
            if didAllow {
                //LogPrint("Push: 권한 허용")
                GlobalShareManager.shared().setLocalData(dataValue: "true", forKey: GLOBAL_DEVICE_ALERT)
            } else {
                //LogPrint("Push: 권한 거부")
                GlobalShareManager.shared().setLocalData(dataValue: "false", forKey: GLOBAL_DEVICE_ALERT)
            }
        })

        application.registerForRemoteNotifications()
        
        self.checkAppFirstrunOrUpdateStatus()
        
        self.window?.overrideUserInterfaceStyle = .light

        application.applicationIconBadgeNumber = 0
        
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LogPrint("applicationWillResignActive")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        LogPrint("applicationWillEnterForeground")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow, Error in
            if didAllow {
                //LogPrint("Push: 권한 허용")
                GlobalShareManager.shared().setLocalData(dataValue: "true", forKey: GLOBAL_DEVICE_ALERT)
            } else {
                //LogPrint("Push: 권한 거부")
                GlobalShareManager.shared().setLocalData(dataValue: "false", forKey: GLOBAL_DEVICE_ALERT)
            }
        })
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LogPrint("applicationWillTerminate")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        LogPrint("applicationDidBecomeActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        LogPrint("applicationDidEnterBackground")
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        // 세로방향 고정
//        return UIInterfaceOrientationMask.portrait
//    }
    
    //******** APNS ********//
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken;
        LogPrint("AppDelegate", "APNs token retrieved: \(deviceToken)")
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        LogPrint(userInfo)
    }

    //백그라운드 또는 포그라운드에서 푸쉬를 받았을 경우
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        LogPrint("didReceiveRemoteNotification")
        
        if UIApplication.shared.applicationState != .active {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func checkAppFirstrunOrUpdateStatus() {
        
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let versionOfLastRun = GlobalShareManager.shared().getLocalData(FIRSTCONFIRM) as? String ?? ""
        
        if versionOfLastRun.count == 0 {
            LogPrint("앱 설치 후 최초 실행")
        } else if versionOfLastRun != currentVersion {
            LogPrint("버전 변경(업데이트) 후 실행")
        } else {
            LogPrint("변경사항 없음")
        }
        
        GlobalShareManager.shared().setLocalData(dataValue: currentVersion!, forKey: FIRSTCONFIRM)
    }
    
    func moveToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
        self.window?.rootViewController = mainController
        self.window?.makeKeyAndVisible()
    }

    func moveToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        self.window?.rootViewController = mainController
        self.window?.makeKeyAndVisible()
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        LogPrint("PUSH CLICK FOREGROUND")
        
        let userInfo = notification.request.content.userInfo
        LogPrint("userInfo : \(userInfo)")
        let arrAPS = userInfo["aps"] as? [String: Any]
        let arrAlert = arrAPS?["alert"] as? [String:Any]
        let strTitle = arrAlert?["title"] as? String ?? ""
        let strBody = arrAlert?["body"] as? String ?? ""
        let strSound = arrAPS?["sound"] as? String ?? ""
        
        let orderStatus = userInfo["gcm.notification.orderStTp"] as? String ?? ""
        let orderId = userInfo["gcm.notification.orderId"] as? String ?? ""
        let fId = userInfo["google.c.fid"] as? String ?? ""
        
        let userInfoList: [AnyHashable: Any] = [
            "message": strBody,
            "orderStatus": orderStatus
        ]
        
        if GlobalShareManager.shared().selectTabIndex == 0 {
            
            NotificationCenter.default.post(name: NSNotification.Name("callPushHome"), object: nil, userInfo: userInfoList)
            
        } else if GlobalShareManager.shared().selectTabIndex == 1 {
            
            if GlobalShareManager.shared().isMoveToDetail == false {
                NotificationCenter.default.post(name: NSNotification.Name("callPushOrderReceipt"), object: nil, userInfo: userInfoList)
                
            } else if GlobalShareManager.shared().isMoveToDetail == true {
                NotificationCenter.default.post(name: NSNotification.Name("callPushOrderReceiptDetail"), object: nil, userInfo: userInfoList)
            }
            
        } else if GlobalShareManager.shared().selectTabIndex == 2 {
            
            NotificationCenter.default.post(name: NSNotification.Name("callPushServiceManagement"), object: nil, userInfo: userInfoList)
            
        } else if GlobalShareManager.shared().selectTabIndex == 3 {
            
            NotificationCenter.default.post(name: NSNotification.Name("callPushSales"), object: nil, userInfo: userInfoList)
            
        } else if GlobalShareManager.shared().selectTabIndex == 4 {
            
            NotificationCenter.default.post(name: NSNotification.Name("callPushMoreMenu"), object: nil, userInfo: userInfoList)
        }
        
        completionHandler([])
    }
    
    // PUSH CLICK
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        LogPrint("PUSH CLICK BACKGROUND")
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let userInfo = response.notification.request.content.userInfo
        LogPrint("userInfo : \(userInfo)")
        let arrAPS = userInfo["aps"] as? [String: Any]
        let arrAlert = arrAPS?["alert"] as? [String:Any]
        let strTitle = arrAlert?["title"] as? String ?? ""
        let strBody = arrAlert?["body"] as? String ?? ""
        let strSound = arrAPS?["sound"] as? String ?? ""

        let orderStatus = userInfo["gcm.notification.orderStTp"] as? String ?? ""
        let orderId = userInfo["gcm.notification.orderId"] as? String ?? ""
        let fId = userInfo["google.c.fid"] as? String ?? ""
        
        if orderStatus == TAB_ORDER_STATUS_ORDER {
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERWAITING
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            
        } else if orderStatus == TAB_ORDER_STATUS_RESERVATIONWAITTING || orderStatus == TAB_ORDER_STATUS_RESERVATIONWAITTING_10 {
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERPROCESSING
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            
        } else if orderStatus == TAB_ORDER_STATUS_ORDERCANCEL {
            GlobalShareManager.shared().order_category_status = TAB_ORDER_ORDERCANCEL
            GlobalShareManager.shared().order_category_content = TAB_ORDER_ORDERTODAY
            
        }
        
        GlobalShareManager.shared().isMoveToOrder = true
        GlobalShareManager.shared().selectTabIndex = 1

        completionHandler()
    }
    
    func postNotification(title: String, body: String) {
        
        LogPrint("PUSH NOTIFICATION~~")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "yapLocalNotification_\(UIApplication.shared.applicationIconBadgeNumber)", content: content, trigger: nil)
        self.userNotificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let newFcmToken = fcmToken
        LogPrint("FCM TOKEN : \(newFcmToken!)")
        
        if let savedFcmToken = GlobalShareManager.shared().getLocalData(FCMTOKEN) as? String {
            
            if savedFcmToken != newFcmToken {
                LogPrint("NEW FCM TOKEN SAVE!!")
                GlobalShareManager.shared().setLocalData(dataValue: newFcmToken!, forKey: FCMTOKEN)
            }
            
        } else {
            GlobalShareManager.shared().setLocalData(dataValue: newFcmToken!, forKey: FCMTOKEN)
        }
    }
    
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        LogPrint("Received data message: \(remoteMessage.description)")
    }
    // [END ios_10_data_message]
}
