//
//  NotificationPermissionViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/05/02.
//

import Foundation
import UIKit

class NotificationPermissionViewController: UIViewController {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTogle: UILabel!
    @IBOutlet weak var labelTogleUse: UILabel!
    @IBOutlet weak var switchNoti: UISwitch!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var viewLeftButton: UIView!
    @IBOutlet weak var labelLeftButtonTitle: UILabel! {
        didSet {
            labelLeftButtonTitle.text = "action_cancel".localized()
        }
    }
    
    @IBOutlet weak var viewRightButton: UIView!
    @IBOutlet weak var labelRightButtonTitle: UILabel! {
        didSet {
            labelRightButtonTitle.text = "action_setting".localized()
        }
    }
    
    var popupType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        switchNoti.isOn = false
        labelTogleUse.text = "popup_notification_permission_nonuse".localized()
        
        labelDescription.text = "popup_notification_permission_description".localized()
//        labelTogle.text = "popup_notification_permission_togle_title".localized()
        labelMessage.text = "popup_notification_permission_message".localized()
        
        viewLeftButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchLeftButton)))
        viewRightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchRightButton)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
        
        if popupType == "deviceNoti" {
            labelTogle.text = "popup_notification_permission_togle_title_device_noti".localized()
            
        } else if popupType == "configAlert" {
            labelTogle.text = "popup_notification_permission_togle_title_config_alert".localized()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func touchLeftButton(sender: UITapGestureRecognizer) {
        LogPrint("touchLeftButton")
        
        self.dismiss(animated: false)
    }
    
    @objc func touchRightButton(sender: UITapGestureRecognizer) {
        LogPrint("touchRightButton")
        
        self.dismiss(animated: false)
        
        let userInfo: [AnyHashable: Any] = [
            "popupType": self.popupType
        ]
        
        NotificationCenter.default.post(name: NSNotification.Name("callSetNoti"), object: nil, userInfo: userInfo)
    }
    
}
