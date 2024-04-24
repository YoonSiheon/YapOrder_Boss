//
//  DetailOrderNumberCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/20.
//

import Foundation
import UIKit

class DetailOrderNumberCell: UITableViewCell {
    
    @IBOutlet weak var imageOrderType: UIImageView!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelOrderType: UILabel!
    @IBOutlet weak var labelOrderProduct: UILabel!
    @IBOutlet weak var labelOrderTime: UILabel!
    
    @IBOutlet weak var labelOrderNo: UILabel! {
        didSet {
            labelOrderNo.text = "order_detail_number".localized()
        }
    }
    @IBOutlet weak var labelOrderProductName: UILabel! {
        didSet {
            labelOrderProductName.text = "order_detail_product".localized()
        }
    }
    @IBOutlet weak var labelOrderQuantity: UILabel! {
        didSet {
            labelOrderQuantity.text = "order_detail_quantity".localized()
        }
    }
    @IBOutlet weak var labelOrderAmount: UILabel! {
        didSet {
            labelOrderAmount.text = "order_detail_saleamount".localized()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
