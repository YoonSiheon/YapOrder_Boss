//
//  CommonFunc.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation
import UIKit
import WebKit
import MaterialComponents.MaterialBottomSheet
import CoreLocation
import CoreTelephony
import AVFoundation
import Photos

let GLOBAL_PASSWORD                           = "password"
let GLOBAL_NOTI_DELAY_TIME                    = "notiDelayTime"
let GLOBAL_PARENTS_NOTI_DELAY_TIME            = "parentsNotiDelayTime"
let PARENTS_NOTI_DELAY_TIME_MAX               = 60 * 10                                 // parents noti delay time(10분)
let NOTI_DELAY_TIME_MAX                       = 60 * 3                                  // noti delay time max(3분)


var soundPlayer: AVAudioPlayer?

func getNotchIdx() -> Int {
    if UIDevice.current.hasNotch {
        return 0
    } else {
        return 1
    }
}

/*
 노치 디자인
 - notch : 44pt
 - normal : 34pt
 일반 디자인
 - notch : 20pt
 - normal : 0pt
*/

func getStatusBarHeight() -> (isHas: Bool, height: Int) {
    var isHas = false
    let statusBarHeight = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
    if statusBarHeight > 0 {
        isHas = true
    }
    
    return (isHas: isHas, height:Int(statusBarHeight))
}

func getHomeBarHeight() -> (isHas: Bool, height: Int) {
    var isHas = false
    let homeBarHeight = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    if homeBarHeight > 0 {
        isHas = true
    }
    
    return (isHas: isHas, height:Int(homeBarHeight))
}

func getScreenSize() -> (width: CGFloat, height: CGFloat) {
    let screenSize: CGRect = UIScreen.main.bounds
    return (screenSize.width, screenSize.height)
}

func checkCameraPermission() {
    
    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
        if granted {
            LogPrint("CAMERA PERMISSION GRANTED")
            
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_TRUE, forKey: GLOBAL_PERMISSION_CAMERA)
        } else {
            LogPrint("CAMERA PERMISSION DENIED")
            
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_FALSE, forKey: GLOBAL_PERMISSION_CAMERA)
        }
    })
    
}

func checkAlbumPermission(){
    
    PHPhotoLibrary.requestAuthorization( { status in
        switch status{
        case .authorized:
            LogPrint("Album: 권한 허용")
            
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_TRUE, forKey: GLOBAL_PERMISSION_ALBUM)
        case .denied, .restricted, .notDetermined:
            LogPrint("Album: 권한 거부")
            
            GlobalShareManager.shared().setLocalData(dataValue: GLOBAL_FALSE, forKey: GLOBAL_PERMISSION_ALBUM)
        default:
            break
        }
    })
}

// keypad용 division분할
func getConstraintWidth(division: CGFloat) -> CGFloat {
    
    var returnWidth: CGFloat = 0.0
    let screenWidth = getScreenSize().width
    
    returnWidth = screenWidth/division
    
    return returnWidth
}

func getAppVersion() -> (stringType: String, intType: Int) {
    
    let appCurrVerString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    let appCurrVerInt = Int(appCurrVerString.replacingOccurrences(of: ".", with: ""))!
    
    return (appCurrVerString, appCurrVerInt)
}

func setViewShadow(view: UIView, type: String = "popup", height: Int = 5) {
    
    if type == "popup" {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowPath = nil
        
    } else if type == "title" {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 5
            view.layer.shadowOffset = CGSize(width: 0, height: 9)
            view.layer.shadowPath = nil
            
        }, completion: {(isCompleted) in
            
        })
    } else if type == "home" {
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.07
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: height)
        view.layer.shadowPath = nil
        
    }
}

func setViewShadowDisable(view: UIView, type: String = "popup") {
    
    if type == "popup" {
        
    } else if type == "title" {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
            
            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.0
            view.layer.shadowRadius = 5
            view.layer.shadowOffset = CGSize(width: 0, height: 9)
            view.layer.shadowPath = nil
            
        }, completion: {(isCompleted) in
            
        })
    }
}

func setAttributeText(text: String, fontSize: CGFloat, weight: UIFont.Weight, originalColor: UIColor, changeText: String, changeFontSize: CGFloat, changeWeight: UIFont.Weight, changeColor: UIColor) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: text, attributes: [
                                                        .font: UIFont.systemFont(ofSize: fontSize, weight: weight),
                                                        .foregroundColor: originalColor,
                                                        .kern: -0.01])
 
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: changeFontSize, weight: changeWeight), range: (text as NSString).range(of: changeText))
    attributedString.addAttribute(.foregroundColor, value: changeColor, range: (text as NSString).range(of: changeText))
    
    return attributedString
}

func getDateFormatter(type: String) -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
//    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = type
    
    return dateFormatter
}

//오늘의 날짜를 반환
func getStringFromDate(date: Date = Date(), format: String = "yyyy-MM-dd", offsetMonth: Int = 0, offsetDay: Int = 0) -> String {
    let dateFormatter = getDateFormatter(type: format)
    
    var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
    
    // Day, Month 둘 중 한 조건만 적용
    if offsetDay != 0 {
        comp.day = comp.day! + offsetDay
    } else if offsetMonth != 0 {
        comp.month = comp.month! + offsetMonth
    } else {
        return dateFormatter.string(from: date)
    }
    
    let targetDate = Calendar.current.date(from: comp)!

    return dateFormatter.string(from: targetDate)
}

//현재 시각의 시간만 가져오는 함수
func getTimetoHour(time: String) -> String {
    var resultTime: String = ""
    
    if time.contains("오전 ") {
        let arrUrl = time.components(separatedBy: "오전 ")
        resultTime = arrUrl[1]
    } else if time.contains("오후 ") {
        let arrUrl = time.components(separatedBy: "오후 ")
        resultTime = arrUrl[1]
    }
    
    return resultTime
}

//24시간의 오전,오후 시간 반환(예 20시 -> 8시)
func getTimeFormatterDate(nowTime: String) -> (strHalfDay: String, arrTime: Array<String>) {
    let selectedTime = getTimetoHour(time: nowTime)
    var strHalfDay = "오전 "
    var arrTime = selectedTime.components(separatedBy: ":")
    if Int(arrTime[0])! > 12 {
        strHalfDay = "오후 "
        arrTime[0] = String(Int(arrTime[0])! - 12)
    }
    
    return (strHalfDay, arrTime)
}

//현재 요일 받아 오는 함수 (예: -> 월)
//날짜를 입력 시 요일 확인
func getDayOfWeek(toDate: String = "") -> String {
    var now = Date()
    if toDate.count > 0 {
        now = toDate.toAllDateString()!
    }
    
    let dateFormatter = getDateFormatter(type: "EEEEEE")
    let convertStr = dateFormatter.string(from: now)
    return convertStr
}

//home - 그래프용
func nowDate(type: String = "0", toDate: String = "") -> String {
    var now = Date()
    if toDate.count > 0 {
        now = toDate.toAllDateString()!
    }
    
    let dateFormatter = getDateFormatter(type: "yyyyMMdd")
    var currentDate = dateFormatter.string(from: now)
    
    var prevDay = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
    
    if type == "4" {            // 01.01
        
        let startIndex = currentDate.index(currentDate.startIndex, offsetBy: 4)
        let endIndex = currentDate.index(currentDate.startIndex, offsetBy: 7)
        var sliced_str = currentDate[startIndex ... endIndex]
        sliced_str.insert(".", at:sliced_str.index(sliced_str.startIndex, offsetBy: 2))
        currentDate = String(sliced_str)
        
    } else if type == "8" {     // 2023.01.01
        
        currentDate.insert(".", at:currentDate.index(currentDate.startIndex, offsetBy: 4))
        currentDate.insert(".", at:currentDate.index(currentDate.startIndex, offsetBy: 7))
        
    } else if type == "-7" {    // 2022.12.24
        
        prevDay.insert(".", at:prevDay.index(prevDay.startIndex, offsetBy: 4))
        prevDay.insert(".", at:prevDay.index(prevDay.startIndex, offsetBy: 7))
        currentDate = prevDay
        
    } else {
        
    }
    
    return currentDate
}

//order search용 (ex: 2023-01-01, 2023-02-01)
func nowDate(search: String = "0") -> (startDate: String, endDate: String) {
    
    let dateFormatter = getDateFormatter(type: "yyyy-MM-dd")
    let currentDate = dateFormatter.string(from: Date())
    var prevDate = dateFormatter.string(from: Date())
    
    if search == "m" {
        prevDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
    } else if search == "w" {
        prevDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
    } else if search == "d" {
        prevDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
    }
    
    return (prevDate, currentDate)
}

//order receipt용 (ex:01/01, 23:59, 일)
func getReceiptDate(date: String) -> (strDate: String, strTime: String, strWeek: String){
    
    let strWeek = getDayOfWeek(toDate:date)
    var startIndex = date.index(date.startIndex, offsetBy: 4)
    var endIndex = date.index(date.startIndex, offsetBy: 7)
    var sliced_str = date[startIndex ... endIndex]
    sliced_str.insert("/", at:sliced_str.index(sliced_str.startIndex, offsetBy: 2))
    let strDate = String(sliced_str)
    
    startIndex = date.index(date.startIndex, offsetBy: 8)
    endIndex = date.index(date.startIndex, offsetBy: 11)
    sliced_str = date[startIndex ... endIndex]
    sliced_str.insert(":", at:sliced_str.index(sliced_str.startIndex, offsetBy: 2))
    let strTime = String(sliced_str)
    
    return (strDate, strTime, strWeek)
}

func isNowToday(nowTime: String) -> Bool {
    let dateFormatter = getDateFormatter(type: "yyyyMMddHHmmss")
    
    let todayCalendar = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
    
    let getToday = String(nowTime[nowTime.index(nowTime.startIndex, offsetBy: 0) ... nowTime.index(nowTime.startIndex, offsetBy: 7)])
    let todayNow = String(todayCalendar[todayCalendar.index(todayCalendar.startIndex, offsetBy: 0) ... todayCalendar.index(todayCalendar.startIndex, offsetBy: 7)])
    
    if getToday == todayNow {
        //LogPrint("today")
        return true
    } else {
        //LogPrint("yesterday")
        return false
    }
}

func isNowToday(today:Date) -> Bool {
    
    let dateFormatter = getDateFormatter(type: "yyyy-MM-dd")
    let currentDate = dateFormatter.string(from: Date())
    let selectDate = dateFormatter.string(from: today)
    
    if currentDate < selectDate {
        //LogPrint("future")
        return false
    } else {
        //if currentDate == selectDate {
        //LogPrint("today")
        //}
        //else if currentDate > selectDate {
        //LogPrint("yesterday")
        //}
        return true
    }
}


func nowWeekday() -> (strDay: String, iDay: Int) {

    var nowDay: String = ""
    let cal = Calendar(identifier: .gregorian)
    let now = Date()
    let comps = cal.dateComponents([.weekday], from: now)
    
    if comps.weekday == 1 {
        nowDay = "일"
    } else if comps.weekday == 2 {
        nowDay = "월"
    } else if comps.weekday == 3 {
        nowDay = "화"
    } else if comps.weekday == 4 {
        nowDay = "수"
    } else if comps.weekday == 5 {
        nowDay = "목"
    } else if comps.weekday == 6 {
        nowDay = "금"
    } else if comps.weekday == 7 {
        nowDay = "토"
    }
    
    return(nowDay, comps.weekday!)
}

//하루에 한번만 실행되었는지 체크 //true:오늘 실행 안됨, false:이미 실행됨
func checkTodayNotRun(localData: String) -> Bool {
    var resultBool: Bool = false
    
    let nowDate = getStringFromDate()
    let openDate = GlobalShareManager.shared().getLocalData(localData) as? String ?? "2000-01-01"
    LogPrint("nowDate : \(nowDate) || openDate : \(openDate)")
    
    let result = nowDate.toAllDate()!.dateCompare(fromDate: openDate.toAllDate()!)
    LogPrint("date result : \(result)")
    if result == "Past" { //과거
        GlobalShareManager.shared().setLocalData(dataValue: nowDate, forKey: localData)

        resultBool = true
    }
    
    return resultBool
}

//22.12.21 카톡 딜레이 시간 체크(10분)
func getParentsNotiDelayCheck() -> Bool {
    var resultBool: Bool = false
    
    let nowDate = nowDate().toAllDateTime()
    let openDate = GlobalShareManager.shared().getLocalData(GLOBAL_PARENTS_NOTI_DELAY_TIME) as? String ?? "2000-01-01 01:01:01"
    let useTime = Int(nowDate!.timeIntervalSince((openDate.toAllDateTime())!))
    LogPrint("Parents usetime : \(useTime)")
    
    if useTime > PARENTS_NOTI_DELAY_TIME_MAX {
        resultBool = true
    }
    
    return resultBool
}

//22.12.21 알림 지속 시간 체크(3분)
func getNotiDelayCheck() -> Bool {
    var resultBool: Bool = true
    
    let nowDate = nowDate().toAllDateTime()
    let openDate = GlobalShareManager.shared().getLocalData(GLOBAL_NOTI_DELAY_TIME) as? String ?? "2000-01-01 01:01:01"
    let useTime = Int(nowDate!.timeIntervalSince((openDate.toAllDateTime())!))
    LogPrint("noti usetime : \(useTime)")
    
    if useTime >= NOTI_DELAY_TIME_MAX {
        resultBool = false
    }
    
    return resultBool
}

func showToast(selfView: UIViewController, message: String, width: CGFloat = 300.0, height: CGFloat = 35) {
    let toastLabel = UILabel(frame: CGRect(x: selfView.view.frame.size.width/2 - (width/2), y: selfView.view.frame.size.height/2, width: width, height: height))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = .systemFont(ofSize: 15, weight: .medium)
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds  =  true
    selfView.view.addSubview(toastLabel)
    UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
    if height > 35 {
        toastLabel.numberOfLines = 2
    } else {
        toastLabel.numberOfLines = 1
    }
}

func showJavaScriptAlert(_ vc: UIViewController, _ message: String, completionHandler: @escaping () -> Void) {

    if message.count > 0 {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            completionHandler()
        })
        alert.addAction(defaultAction)
        vc.present(alert, animated: true)
    } else {
        completionHandler()
    }
}

func showJavaScriptConfirmAlert(_ vc: UIViewController, _ message: String, completionHandler: @escaping (Bool) -> Void) {

    if message.count > 0 {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default, handler: { action in
            completionHandler(true)
        })

        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: { action in
            completionHandler(false)
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    } else {
        completionHandler(false)
    }
}

func setPopupBottomSheet(vc: UIViewController, touchClose: Bool, bottomHeight: CGFloat) -> UIViewController {
    
    // MDC 바텀 시트로 설정
    let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc)
    
    bottomSheet.dismissOnBackgroundTap = touchClose
    bottomSheet.dismissOnDraggingDownSheet = touchClose

    var bottomSheetHeight: CGFloat = bottomHeight
    
    if UIDevice.current.hasNotch {
        bottomSheetHeight -= 40.0
    } else {
        bottomSheetHeight -= 20.0
    }
    
    if #available(iOS 13.0, *) {
        bottomSheet.accessibilityRespondsToUserInteraction = true
    } else {// iOS Login unavailable
        bottomSheetHeight -= 60.0
    }
    
    bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = bottomSheetHeight
    
    bottomSheet.scrimColor = UIColor.black.withAlphaComponent(0.5)
    
    return bottomSheet
}

func setDistance(fromLat: Double, fromLon: Double, toLat: Double, toLon: Double) -> CLLocationDistance {
    let from = CLLocation(latitude: fromLat, longitude: fromLon)
    let to = CLLocation(latitude: toLat, longitude: toLon)
    return from.distance(from: to)
}

// return:   true: calling, false: not calling
func isCalling() -> Bool {
    let callCenter = CTCallCenter()
    var calling = false
    
    if let currentCalls = callCenter.currentCalls {
        for call in currentCalls {
            if call.callState == CTCallStateConnected {
                calling = true
                break
            }
        }
    }
    return calling
}

//webkit configration
public func createWebviewConfiguration(handler: WKScriptMessageHandler, processPool: WKProcessPool) -> WKWebViewConfiguration{
    
    let pref = WKPreferences()
    pref.javaScriptEnabled = true
    pref.javaScriptCanOpenWindowsAutomatically = true
    
    let contentCon = WKUserContentController()
    contentCon.add(handler, name: "setBell")
    contentCon.add(handler, name: "setAlert")
    contentCon.add(handler, name: "setVersion")
    contentCon.add(handler, name: "uploadImgReq")
//    let script = WKUserScript(source: "", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//    let scriptAlert = WKUserScript(source: "setAlert", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//    contentCon.addUserScript(scriptAlert)
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentCon
    config.preferences = pref
    config.processPool = processPool
    
    WKWebsiteDataStore.nonPersistent()
    HTTPCookieStorage.shared.cookieAcceptPolicy = .always
    
    // Header User-Agent ADD APP VALUE
//        config.applicationNameForUserAgent = "/YapOrderBoss"
    
    return config
}
// yapceo alert?use=true|false , bell?use=true|false
func isURLreturnUse(URL: String) -> String {
    let queryItems = URLComponents(string: URL)?.queryItems
    let param1 = queryItems?.filter({$0.name == "use"}).first
    
    return param1?.value ?? ""
}

func isURLreturnFilename(URL: String) -> String {
    let queryItems = URLComponents(string: URL)?.queryItems
    let param1 = queryItems?.filter({$0.name == "filename"}).first
    
    return param1?.value ?? ""
}

func isURLreturnImgUpload(URL: String) -> String {
    let queryItems = URLComponents(string: URL)?.queryItems
    let param1 = queryItems?.filter({$0.name == "target"}).first
    
    return param1?.value ?? ""
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//file save

func deletePasswordFile() {
    
    //공통인스턴스 yaptest 경로에 yaptest.txt 파일
    let fileManager: FileManager = FileManager.default
    let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryPath: URL = documentPath.appendingPathComponent("company")
    let textPath: URL = directoryPath.appendingPathComponent("companyPassword.txt")
    
    do {
        try fileManager.removeItem(at: textPath)
    } catch let e {
        print(e.localizedDescription)
    }
}

func setPasswordFile(value: String) {
    
    let fileManager: FileManager = FileManager.default
    let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryPath: URL = documentPath.appendingPathComponent("company")
    let textPath: URL = directoryPath.appendingPathComponent("companyPassword.txt")
    
    // 파일매니저로 디렉토리 생성하기
    do {
        // 아까 만든 디렉토리 경로에 디렉토리 생성 (폴더가 만들어진다.)
        try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false, attributes: nil)
    } catch let e {
        print(e.localizedDescription)
    }
    
    // 아까 만든 'SchoolZonePassword.txt' 경로에 텍스트 쓰기
    if let data: Data = value.data(using: String.Encoding.utf8) { // String to Data
        do {
            try data.write(to: textPath) // 위 data를 "hi.txt"에 쓰기
        } catch let e {
            print(e.localizedDescription)
        }
    }
}

func getPasswordFile() -> String {
    
    var result: String = ""
    
    let fileManager: FileManager = FileManager.default
    let documentPath: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryPath: URL = documentPath.appendingPathComponent("company")
    let textPath: URL = directoryPath.appendingPathComponent("companyPassword.txt")
    
    // 파일매니저로 디렉토리 생성하기
    do {
        // 아까 만든 디렉토리 경로에 디렉토리 생성 (폴더가 만들어진다.)
        try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false, attributes: nil)
    } catch let e {
        print(e.localizedDescription)
    }
    
    // 만든 파일 불러와서 읽기.
    do {
        let dataFromPath: Data = try Data(contentsOf: textPath) // URL을 불러와서 Data타입으로 초기화
        result = String(data: dataFromPath, encoding: .utf8) ?? "문서없음" // Data to String
    } catch let e {
        print(e.localizedDescription)
    }
    
    return result
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//keychain save

func addItemsOnKeyChain(pwd: Any) {
    let account = "company_" + GLOBAL_PASSWORD
    let password = (pwd as AnyObject).data(using: String.Encoding.utf8.rawValue)!
    let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                               kSecAttrAccount: account,
                                 kSecValueData: password as Any]
    let status = SecItemAdd(addQuery as CFDictionary, nil)
    if status == errSecSuccess {
        LogPrint("add success")
    } else if status == errSecDuplicateItem {
        updateItemOnKeyChain(value: password, key: account)
    } else {
        LogPrint("add failed")
    }
}

func updateItemOnKeyChain(value: Any, key: Any) {
    let previousQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                          kSecAttrAccount: key]
    let updateQuery: [CFString: Any] = [kSecValueData: value]
    let status = SecItemUpdate(previousQuery as CFDictionary, updateQuery as CFDictionary)
    if status == errSecSuccess {
        LogPrint("update complete")
    } else {
        LogPrint("not finished update")
    }
}

func readItemsOnKeyChain() -> String {
    let account = "company_" + GLOBAL_PASSWORD
    let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: account,
                                kSecReturnAttributes: true,
                                kSecReturnData: true]
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
        LogPrint("read failed")
        return ""
    }
    guard let existingItem = item as? [String: Any] else { return "" }
    guard let data = existingItem[kSecValueData as String] as? Data else { return "" }
    guard let password = String(data: data, encoding: .utf8) else { return "" }

    return password
}

func deleteItemOnKeyChain() {
    let account = "company_" + GLOBAL_PASSWORD
    let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: account]
    let status = SecItemDelete(deleteQuery as CFDictionary)
    if status == errSecSuccess {
        LogPrint("remove key-data complete")
    } else {
        LogPrint("remove key-data failed")
    }
}

func soundDefaultOrder() {
    
    let soundName = "기본음_기본주문"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundDefaultReservation() {
    
    let soundName = "기본음_예약주문"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundDefaultReservation_before10() {
    
    let soundName = "기본음_예약주문10분전"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundLimchangjungOrder() {
    
    let soundName = "임창정음성_기본주문"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundLimchangjungReservation() {
    
    let soundName = "임창정음성_예약주문"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundLimchangjungReservation_before10() {
    
    let soundName = "임창정음성_예약주문10분전"
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
        return
    }
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        soundPlayer?.numberOfLoops = 0
        soundPlayer?.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func soundStop() {
    soundPlayer?.stop()
}
