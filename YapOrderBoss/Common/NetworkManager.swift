//
//  NetworkManager.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Alamofire
import CoreTelephony

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class NetworkManager {
    
    // MARK: - Properties
    var AlamofireAppManager: Session?
    var baseURL: String = ""
    
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(baseURL: BASE_URL)
        return networkManager
    }()
    
    // Initialization
    private init(baseURL: String) {
        self.baseURL = baseURL
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData// NO-CHACHE
        configuration.timeoutIntervalForRequest = 10
        let delegate = Session.default.delegate
        AlamofireAppManager = Session.init(configuration: configuration,
                                           delegate: delegate,
                                           startRequestsImmediately: true,
                                           cachedResponseHandler: nil)
    }
    
    func getAPIURL() -> String {
        var url: String = GlobalShareManager.shared().globalAPI
        if url == "http://" || url == "" {
           url = API_URL
        }
        return url
    }

    func getFrontURL() -> String {
        var url: String = GlobalShareManager.shared().globalFront
        if url == "http://" || url == "" {
           url = BASE_URL
        }
        return url
    }

    // MARK: - Accessors
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    func getHttpHeaders() -> HTTPHeaders {

        var carrierName = ""
        if let carrier = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.first?.value {
            carrierName = carrier.carrierName ?? "unKnown"
        } else {
            carrierName = "unKnown"
        }
        
        let headers: HTTPHeaders = [
            "User-Agent": "iphone/yapOrderCeo",
            "OS": "I",
            "OS-VER": UIDevice.current.systemVersion,
            "Content-Type": "application/json;charset=utf-8",
            "Accept": "application/json",
            "DEVICE-MODEL": UIDevice.modelName,
            "MARKET": carrierName,
            "Content-Language": Locale.current.languageCode!
        ]
        
        return headers
    }

    //*****************************************************************************************//
    
    func getAppVersion(completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()

        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let result = Dictionary<String, String>()
        let tempUrl: String = "?appKindCd=YC&dvcOsCd=IO"

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_APPVERSION + tempUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                    switch response.result {
                    case .success(let value):

                        do {
                            let statusCode: Int = (response.response?.statusCode)!

                            if let dict = value.toJSON() as? NSDictionary {
                                completion(true, statusCode, dict)
                            } else {
                                completion(true, statusCode, result as NSDictionary)
                            }
                        }
                    case .failure( _):
                        completion(false, 999, result as NSDictionary)
                    }
            }
        }
    }
    
    //로그인
    func getLogin(loginId: String, loginPw: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let params: [String: Any] = [
            "loginId": loginId,
            "password": loginPw.sha256()
        ]
        
        let result = Dictionary<String, String>()
        
        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_LOGINMAIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    
                    do {
                        let statusCode: Int = (response.response?.statusCode)!
                        
                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //로그아웃
    func getLogout(token: String, storeCode: String,completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let pushId = GlobalShareManager.shared().getLocalData(GLOBAL_PUSHID) as? Int64 ?? 0
        let posNo = GlobalShareManager.shared().getLocalData(GLOBAL_POSNO) as? String ?? ""
        
        let params: [String: Any] = [
            "storeCode": storeCode,
            "deviceNo": (UIDevice.current.identifierForVendor?.uuidString)!, //udid
            "pushId": pushId,
            "posNo": posNo
        ]
        
        let result = Dictionary<String, String>()
        
        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_LOGOUT, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):
                    
                    do {
                        let statusCode: Int = (response.response?.statusCode)!
                        
                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //푸쉬토큰 등록 - 로그인 후 바로 호출
    func getPushToken(token: String, storeCode: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {

        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
//        let tempNo = (UIDevice.current.identifierForVendor?.uuidString)!
//        LogPrint("deviceNo:\(tempNo)")
        
        let params: [String: Any] = [
            "storeCode": storeCode,
            "deviceNo": (UIDevice.current.identifierForVendor?.uuidString)!, //udid
            "osTp": "IOS",
            "osVer": UIDevice.current.systemVersion,
            "pushTkn": GlobalShareManager.shared().getLocalData(FCMTOKEN) as? String ?? ""
        ]

        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_PUSHTOKEN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //매장정보 조회
    func getStore(token: String, storeCode: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {

        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_STORE + storeCode, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //주문내역 조회
    func getOrders(token: String, storeCode: String, startDate: String = "", endDate: String = "", orderStatus: String = "", keyWord: String = "", pageNo: String = "1", pageSize: String = "1", completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let tempUrl: String = "?storeCode=\(storeCode)&startDate=\(startDate)&endDate=\(endDate)&orderStatus=\(orderStatus)&keyWord=\(keyWord)&pageNo=\(pageNo)&pageSize=\(pageSize)"
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_ORDERS + tempUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    
                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //오늘의 주문내역 조회
    func getOrdersToday(token: String, storeCode: String, progress: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let tempUrl: String = "?storeCode=\(storeCode)&orderDate=\(nowDate(type: "0", toDate: ""))&orderProgress=\(progress)"
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_ORDERS_TODAY + tempUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //조리시간 설정조회
    func getCookTimeInfo(token: String, storeCode: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
    
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]

        let params: [String: Any] = [
            "storeCode": storeCode
        ]

        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_COOKTIME, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //조리시간설정 및 수정
    func getCookTimeInfoUpdate(token: String, storeCode: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
    }
    
    //취소사유 목록 조회
    func getCancelReason(token: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_CANCEL_REASON, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //주문상세 조회
    func getOrderDetail(token: String, orderId: Int, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let tempUrl: String = URL_ORDERS + "/\(orderId)" + URL_ORDERS_DETAIL
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + tempUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //영업일보 조회
//    func getSalesInfo(token: String, storeCode: String, startDate: String = "", endDate: String = "", completion: @escaping (Bool, Int, NSDictionary) -> ()) {
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json; charset=utf-8",
//            "Authorization": "Bearer " + token
//        ]
//
//        let tempUrl: String = "?storeCode=\(storeCode)&startDateTime=\(startDate)0000&endDateTime=\(endDate)2359"
//
//        let result = Dictionary<String, String>()
//
//        if Connectivity.isConnectedToInternet() == false {
//            completion(false, 999, result as NSDictionary)
//        } else {
//            AlamofireAppManager?.request(API_BASE_URL + URL_SALES_INFO + tempUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseString { response in
//                switch response.result {
//                case .success(let value):
//
//                    do {
//                        let statusCode: Int = (response.response?.statusCode)!
//
//                        if let dict = value.toJSON() as? NSDictionary {
//                            completion(true, statusCode, dict)
//                        } else {
//                            completion(true, statusCode, result as NSDictionary)
//                        }
//                    }
//                case .failure( _):
//                    completion(false, 999, result as NSDictionary)
//                }
//            }
//        }
//    }
    
    //HOME 탭 data 조회
    func getHomeData(token: String, storeCode: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let params: [String: Any] = [
            "storeCode": storeCode
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_HOME_DATA, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //home 임시영업중지 데이터 전달
    func getSalesClosed(token: String, storeCode: String, bizStopYn: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let params: [String: Any] = [
            "storeCode": storeCode,
            "bizStopYn": bizStopYn
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_SALES_CLOSE_UPDATE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //주문접수, 상품준비완료 등 주문상태변경
    func getOrderStatus(token: String, storeCode: String, orderId: String, saleId: String, orderStatus: String, orderType: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let params: [String: Any] = [
            "storeCode": storeCode,
            "orderId": orderId,
            "saleId": saleId,
            "orderStatus": orderStatus,
            "orderType": orderType
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_ORDERS_STATUS, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    //주문상태변경 - 취소 상태 전달
    func getOrderCancel(token: String, storeCode: String, orderId: String, saleId: String, orderStatus: String, orderType: String, cancelReasonType: String, cancelReason: String, completion: @escaping (Bool, Int, NSDictionary) -> ()) {
        
        let APIUrl = getAPIURL()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer " + token
        ]
        
        let params: [String: Any] = [
            "storeCode": storeCode,
            "orderId": orderId,
            "saleId": saleId,
            "orderStatus": orderStatus,
            "orderType": orderType,
            "cancelReasonType": cancelReasonType,
            "cancelReason": cancelReason
        ]
        
        let result = Dictionary<String, String>()

        if Connectivity.isConnectedToInternet() == false {
            completion(false, 999, result as NSDictionary)
        } else {
            AlamofireAppManager?.request(APIUrl + URL_ORDERS_CANCEL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
                switch response.result {
                case .success(let value):

                    do {
                        let statusCode: Int = (response.response?.statusCode)!

                        if let dict = value.toJSON() as? NSDictionary {
                            completion(true, statusCode, dict)
                        } else {
                            completion(true, statusCode, result as NSDictionary)
                        }
                    }
                case .failure( _):
                    completion(false, 999, result as NSDictionary)
                }
            }
        }
    }
    
    
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
    
    public func isConnective() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
