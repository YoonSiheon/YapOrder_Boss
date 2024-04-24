//
//  OrderTableComment.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/02.
//

import Foundation
import UIKit

class OrderTableCommentCell: UITableViewCell {
    
    @IBOutlet weak var labelOrderTableComment: UILabel!
    
    var OrderCount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initComment() {
        
        if OrderCount == 0 {
            labelOrderTableComment.text = "order_table_comment_none".localized()
        } else {
            labelOrderTableComment.text = "order_table_comment_in".localized()
        }
    }
    
    
}
