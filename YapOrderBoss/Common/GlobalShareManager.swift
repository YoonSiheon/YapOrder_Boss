//
//  GlobalShareManager.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation

class GlobalShareManager{
    
    //URL setting(default url, local url)
    var globalAPI: String = ""
    var globalFront: String = ""
    
    //select Tab Index
    var selectTabIndex: Int = 0
    
    //home data - /ceo/main
    var homeOrderArray = Dictionary<String, Any>()
    var homeLastWeekArray = Dictionary<String, Any>()
    var homeThisWeekArray = Dictionary<String, Any>()
    var homeLastWeekDailySalesArray = Array<homeDailySalesData>()
    var homeThisWeekDailySalesArray = Array<homeDailySalesData>()
    var homeFavoriteArray = Array<homeFavoriteData>()
    
    //order(주문접수) 관련
    var orderTodayArray = Array<orderReceiptData>()     //최초 모든 status 데이터가 저장되는 array
    var orderSearchArray = Array<orderReceiptData>()    //검색시 데이터가 저장되는 array

    //order detail 관련
    var orderDetailArray = Dictionary<String, Any>()
    var orderDiscountArray = Array<orderDiscountListData>()
    var orderProductArray = Array<orderProductListData>()
    var optionName: [String] = []
    var optionAmount: [String] = []
    
    //취소사유 관련
    var orderCancelReasonArray = Array<orderCancelReasonData>()
    
    //조리시간 관련
    var orderEstimateTimeArray = Array<Int>()
    //type:00 안내없음 -> 2버튼 확인 팝업, type:01 항상같은시간 -> minute에 설정된 시간으로, type:02 매번 시간 선택 -> 시간 선택 팝업
    var cookTimeType: String = ""
    var cookTimeTypeText: String = ""
    var cookTimeMinute: Int = 0
    
    //home order count
    var order_countOrder: Int = 0
    var order_countING:Int = 0
    var order_countComplete:Int = 0
    var order_countCancel:Int = 0
    
    //order 오늘주문내에 컨텐츠 타입(오늘주문, 전체주문)
    var order_category_content: Int = 0
    //order 오늘주문내에 카테고리 타입(접수대기, 처리중, 완료, 취소)
    var order_category_status: Int = 0
    
    //백그라운드 에서 order 로 이동하였는지 저장
    var isMoveToOrder: Bool = false
    //주문접수 에서 orderDetail 로 이동하였는지 저장
    var isMoveToDetail: Bool = false
    
    //더보기 에서 tab 이동이 필요한 url 호출시 탭이동을 위해 url 저장
    var move_URL: String = ""
    
    //더보기 알림설정 저장용
    var more_setNoti: String = ""
    //더보기 주문알림음 저장용
    var more_setBell: String = ""
    var more_setBellName: String = ""
    
    var permissionCamera: String = ""
    var permissionAlbum: String = ""
    
    public static var sharedGlobalShareManager: GlobalShareManager = {
        let globalsharemanager = GlobalShareManager()
        
        // Configuration
        // ...
        
        return globalsharemanager
    }()
    
    private init() {}
    
    class func shared() -> GlobalShareManager {
        return sharedGlobalShareManager
    }
    
    func setLocalData(dataValue value: Any,forKey defaultName: String) -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.set( value, forKey: defaultName)
        userDefaults.synchronize()
    }
    
    func removeLocalData(forKey defaultName: String) -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: defaultName)
        userDefaults.synchronize()
    }
    
    func getLocalData(_ forKey:String) -> Any? {
        let userDefaults = UserDefaults.standard
        // let data = userDefaults.value(forKey:forKey)
        if let userType = userDefaults.value(forKey: forKey){
            return userType
        }else{
            return nil
        }
    }
    
    func removeAllData() -> Void {
        let domain = Bundle.main.bundleIdentifier!
        let userDefaults = UserDefaults.standard
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }

}
