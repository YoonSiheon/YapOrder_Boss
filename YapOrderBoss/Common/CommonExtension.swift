//
//  CommonExtension.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation
import UIKit
import WebKit
import SystemConfiguration
import CommonCrypto

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    var isDevice: Bool {
        #if IOS_SIMULATOR
            return false
        #else
            return true
        #endif
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)" //최신 24/01/26
                
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4S"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5S"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6S"
            case "iPhone8,2":                               return "iPhone 6S Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE 2nd Gen"
            case "iPhone13,1":                              return "iPhone 12 Mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPhone14,4":                              return "iPhone 13 Mini"
            case "iPhone14,5":                              return "iPhone 13"
            case "iPhone14,2":                              return "iPhone 13 Pro"
            case "iPhone14,3":                              return "iPhone 13 Pro Max"
            case "iPhone14,6":                              return "iPhone SE 3nd Gen"
            case "iPhone14,7":                              return "iPhone 14"
            case "iPhone14,8":                              return "iPhone 14 Plus"
            case "iPhone15,2":                              return "iPhone 14 Pro"
            case "iPhone15,3":                              return "iPhone 14 Pro Max"
            case "iPhone15,4":                              return "iPhone 15"
            case "iPhone15,5":                              return "iPhone 15 Plus"
            case "iPhone16,1":                              return "iPhone 15 Pro"
            case "iPhone16,2":                              return "iPhone 15 Pro Max" //최신 24/01/26
                
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4rd generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5rd generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6rd generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7rd generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8rd generation)"
            case "iPad12,1", "iPad12,2":                    return "iPad (9rd generation)"
            case "iPad13,18", "iPad13,19":                  return "iPad (10rd generation)" //최신 24/01/26
                
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4rd generation)"
            case "iPad13,16", "iPad13,17":                  return "iPad Air (5rd generation)" //최신 24/01/26
                
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini (5nd generation)"
            case "iPad14,1", "iPad14,2":                    return "iPad Mini (6nd generation)" //최신 24/01/26
                
            case "iPad6,3", "iPad6,4":                              return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                              return "iPad Pro (12.9-inch)"
            case "iPad7,3", "iPad7,4":                              return "iPad Pro (10.5-inch) (2nd generation)"
            case "iPad7,1", "iPad7,2":                              return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":        return "iPad Pro (11-inch) (3nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":        return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,9", "iPad8,10":                             return "iPad Pro (11-inch) (4nd generation)"
            case "iPad8,11", "iPad8,12":                            return "iPad Pro (12.9-inch) (4rd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":    return "iPad Pro (11-inch) (5rd generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPad Pro (12.9-inch) (5rd generation)"
            case "iPad14,3", "iPad14,4":                            return "iPad Pro (11-inch) (6rd generation)"
            case "iPad14,5", "iPad14,6":                            return "iPad Pro (12.9-inch) (6rd generation)" //최신 24/01/26
                
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

extension UIApplication {
    
    static func openAppSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            return
        }
    }
}

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

extension HTTPCookieStorage {
    
    static func clear() {
        LogPrint("HTTP Cookie Storage Clear")
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    static func save() {
        var cookies = [Any]()
        if let newCookies = HTTPCookieStorage.shared.cookies {
            for newCookie in newCookies {
                var cookie = [HTTPCookiePropertyKey : Any]()
                cookie[.name] = newCookie.name
                cookie[.value] = newCookie.value
                cookie[.domain] = newCookie.domain
                cookie[.path] = newCookie.path
                cookie[.version] = newCookie.version
                if let date = newCookie.expiresDate {
                    cookie[.expires] = date
                }
                cookies.append(cookie)
                
                WKWebsiteDataStore.default().httpCookieStore.setCookie(newCookie, completionHandler: {})
            }
            
            UserDefaults.standard.setValue(cookies, forKey: "cookies")
            UserDefaults.standard.synchronize()
        }

        LogPrint("Cookie save!!!")
    }
    
    static func restore() {
        if let cookies = UserDefaults.standard.value(forKey: "cookies") as? [[HTTPCookiePropertyKey : Any]] {
            for cookie in cookies {
                if let oldCookie = HTTPCookie(properties: cookie) {
                    HTTPCookieStorage.shared.setCookie(oldCookie)
                    WKWebsiteDataStore.default().httpCookieStore.setCookie(oldCookie, completionHandler: {})
                }
            }
        }
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

extension Date {
    static func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
        
        let formateDate = dateFormatter.date(from:string)!
//        dateFormatter.dateFormat = "dd-MM-yyyy" // Output Formated
        dateFormatter.dateFormat = "yyyy-MM-dd" // Output Formated
        
        print ("Print :\(dateFormatter.string(from: formateDate))")//Print :02-02-2018
        return dateFormatter.string(from: formateDate)
    }
    
    public func dateCompare(fromDate: Date) -> String {
        var strDateMessage:String = ""
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future" //미래
            break
        case .orderedDescending:
            strDateMessage = "Past" //과거
            break
        case .orderedSame:
            strDateMessage = "Same" //현재
            break
        default:
            strDateMessage = "Error"
            break
        }
        return strDateMessage
    }
}

extension UIWindow {
    
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
    
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true }
    
    var className: String {
         NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.3, alpha: CGFloat = 0.5) {
        self.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeOut(duration: TimeInterval = 0.3, alpha: CGFloat = 0.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }, completion: {(isCompleted) in
            self.isHidden = true
        })
    }
    
    func lineMove(duration: TimeInterval = 0.3, leftConstaint: CGFloat = 0.0) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(translationX: leftConstaint, y: 0.0)
        }, completion: {(isCompleted) in

        })
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
//        layer.borderWidth = 0
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}

extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    func split(regex pattern: String) -> [String] {
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
    
    func strikeThrough(_ foregroundColor: UIColor) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(
            NSAttributedString.Key.foregroundColor, value: foregroundColor, range: NSMakeRange(0,attributeString.length))
        //yapLog("STRIKE THROUGH STRING", "text : \(attributeString)")
        return attributeString
    }
    
    func removeStrikeThrough(_ foregroundColor: UIColor) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(
            NSAttributedString.Key.foregroundColor, value: foregroundColor, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func underLine(_ foregroundColor: UIColor) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(
            NSAttributedString.Key.foregroundColor, value: foregroundColor, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func underLine(_ foregroundColor: UIColor, _ fontSize: CGFloat = 0.0) -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(
            NSAttributedString.Key.foregroundColor, value: foregroundColor, range: NSMakeRange(0, attributeString.length))
        if fontSize > 0.0 {
            attributeString.addAttribute(
                NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSMakeRange(0, attributeString.length))
        }
        return attributeString
    }
    
    func lineSpaced(_ spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return attributedString
    }
    
    func getAttrText(color: UIColor, size: CGFloat = 13, lineSpacing: CGFloat = 0.0) ->  NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        if lineSpacing > 0 {
            paragraphStyle.lineSpacing = lineSpacing
        }
        
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : color,
            .font : UIFont.systemFont(ofSize: size),
            .paragraphStyle: paragraphStyle
        ]
        
        let string = NSAttributedString(string: "\(self)", attributes: attributes)
        return string
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toAllDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toAllDateTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func toAllDateString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func encodeUrl() -> String?
    {
        let finalString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "+", with: "%2b")
        return finalString
    }
    
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
    
}

extension Int {
    func toComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Double {
    var toString: String {
        return NSNumber(value: self).stringValue
    }
}

extension TimeZone {
    
    func offsetFromUTC() -> String {
        
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetInHours() -> String {
        
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    //sha-256을 호출, 리턴을 byte[]로 받기 때문에, String 변환이 필요
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

