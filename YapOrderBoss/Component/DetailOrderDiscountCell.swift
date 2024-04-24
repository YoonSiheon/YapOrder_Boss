//
//  DetailOrderDiscountCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/20.
//

import Foundation
import UIKit

class DetailOrderDiscountCell: UITableViewCell {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var labelDiscountToday: UILabel! {
        didSet {
            labelDiscountToday.text = "order_detail_today_discount".localized()
        }
    }
    
    @IBOutlet weak var labelDiscountAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addDiscountList() {
        
        let labelProductArea = labelDiscountToday.safeAreaLayoutGuide
        let labelAmountArea = labelDiscountAmount.safeAreaLayoutGuide
        
        let discountArray = GlobalShareManager.shared().orderDiscountArray
        var realCount: Int = 0
        for i in stride(from: 0, to: discountArray.count, by: 1) {
            
            if discountArray[i].productCode!.count == 0 {
                
                if realCount == 0 {
                    
                    self.labelDiscountToday.text = discountArray[i].discountName
                    self.labelDiscountToday.textColor = COMMON_ORANGE
                    self.labelDiscountAmount.text = "-\(String(Int(discountArray[i].discountAmount!).toComma()))"
                    self.labelDiscountAmount.textColor = COMMON_ORANGE
                    
                } else {
                    
                    let constant: CGFloat = CGFloat(4 * i)

                    let labelOptionName = UILabel()
                    viewContent.addSubview(labelOptionName)

                    labelOptionName.text = discountArray[i].discountName
                    labelOptionName.textColor = COMMON_ORANGE
                    labelOptionName.font = UIFont(name:"Roboto", size:CGFloat(16))
                    labelOptionName.leadingAnchor.constraint(equalTo: labelProductArea.leadingAnchor, constant: 0).isActive = true
                    labelOptionName.topAnchor.constraint(equalTo: labelProductArea.bottomAnchor, constant: constant).isActive = true
                    labelOptionName.translatesAutoresizingMaskIntoConstraints = false

                    let labelOptionAmount = UILabel()
                    viewContent.addSubview(labelOptionAmount)

                    labelOptionAmount.text = "-\(String(Int(discountArray[i].discountAmount!).toComma()))"
                    labelOptionAmount.textColor = COMMON_ORANGE
                    labelOptionAmount.font = UIFont(name:"Roboto", size:CGFloat(16))
                    labelOptionAmount.trailingAnchor.constraint(equalTo: labelAmountArea.trailingAnchor, constant: 0).isActive = true
                    labelOptionAmount.topAnchor.constraint(equalTo: labelAmountArea.bottomAnchor, constant: constant).isActive = true
                    labelOptionAmount.translatesAutoresizingMaskIntoConstraints = false
                }
                
                realCount += 1
            }
        }
        
    }
    
}
