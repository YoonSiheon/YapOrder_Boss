//
//  PopupCalendarViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/07.
//

import Foundation
import UIKit
import SnapKit

class PopupCalendarViewController: BasePopupViewController {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var calendarPicker: UIDatePicker!
    
    
    var popupType: String = ""
    
    var state: String = ""
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        self.baseViewBack = self.viewBack
        self.baseViewPopup = self.viewPopup
        self.basePopupType = self.popupType
        
        setViewShadow(view:viewPopup)
        
        calendarPicker.setDate(date!, animated: false)
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchBackView)))
        calendarPicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
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
        LogPrint("viewWillDisAppear")
    }
    
    @objc func touchBackView(_ sender: UIDatePicker) {
        LogPrint("touchBackView")
        hideAnim(type: .none, position: .none) { }
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        LogPrint(sender.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.string(from: sender.date)
        
        if !isNowToday(today: sender.date) {
            
            if let viewController = UIStoryboard.init(name: "Popup", bundle: nil).instantiateViewController(withIdentifier: "PopupConfirmViewController") as? PopupConfirmViewController {
                viewController.popupState = "calendarOverDay"
                viewController.showAnim(vc: self, bgColor: 0.5, tapbarHidden: true, type: .fadeInOut, position: .center, parentAddView: self.view) { }
            }
            
            return
        }
        
        if state == "startDate" {
            
            let userInfoList: [AnyHashable: Any] = [
                "startDate": dateFormatter.string(from: sender.date),
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callbackStartDate"), object: nil, userInfo: userInfoList)
            
        } else if state == "endDate" {
            
            let userInfoList: [AnyHashable: Any] = [
                "endDate": dateFormatter.string(from: sender.date),
            ]
            NotificationCenter.default.post(name: NSNotification.Name("callbackEndDate"), object: nil, userInfo: userInfoList)
        }
        
        hideAnim(type: .none, position: .none) { }
    }
    
}
