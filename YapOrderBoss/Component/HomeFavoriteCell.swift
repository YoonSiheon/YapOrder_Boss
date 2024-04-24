//
//  HomeFavoriteCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/17.
//

import Foundation
import UIKit

class HomeFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = "home_favorite_title".localized()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
}
