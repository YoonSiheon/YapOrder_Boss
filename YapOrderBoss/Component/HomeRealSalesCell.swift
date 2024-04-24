//
//  HomeRealSales.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/17.
//

import Foundation
import UIKit

class HomeRealSalesCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = "home_realsales_title".localized()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        LogPrint("actionDetail")
    }
    
}
