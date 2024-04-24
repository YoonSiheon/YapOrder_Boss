//
//  HomeCategoryCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/17.
//

import Foundation
import UIKit

class HomeCategoryCell: UITableViewCell {
    
    var tabBarController: UITabBarController?

    @IBOutlet weak var btnOrderReceipt: UIButton! {
        didSet {
            btnOrderReceipt.setTitle("action_order_receipt".localized(), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionOrderReceipt(_ sender: Any) {
        LogPrint("actionOrderReceipt")
        
//        self.inputViewController?.tabBarController?.selectedIndex = 1
        
        self.tabBarController?.selectedIndex = 1
    }
    
}
