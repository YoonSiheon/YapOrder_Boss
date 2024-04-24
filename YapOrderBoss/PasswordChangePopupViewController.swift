//
//  PasswordChangePopupViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/05/02.
//

import Foundation
import UIKit

class PasswordChangePopupViewController: UIViewController {
    
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var labelButtonTitle: UILabel! {
        didSet {
            labelButtonTitle.text = "action_confirm".localized()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        labelDescription.text = "popup_password_change_description".localized()
        labelMessage.text = "popup_password_change_message".localized()
        
        viewButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchButton)))
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
    
    @objc func touchButton(sender: UITapGestureRecognizer) {
        LogPrint("touchButton")
        
        self.dismiss(animated: false)
    }
    
}
