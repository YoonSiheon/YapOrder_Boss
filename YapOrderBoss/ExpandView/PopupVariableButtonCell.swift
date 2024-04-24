//
//  PopupVariableButtonCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/16.
//

import Foundation
import UIKit

class PopupVariableButtonCell: UITableViewCell {
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var labelButton: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setBorderColor(select: Bool) {
        
        if select {
            viewButton.borderColor = COMMON_ORANGE
        } else {
            viewButton.borderColor = COMMON_GRAY3
        }
        
    }
    
}
