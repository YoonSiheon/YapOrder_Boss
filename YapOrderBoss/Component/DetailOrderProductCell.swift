//
//  DetailOrderProductCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/20.
//

import Foundation
import UIKit

class DetailOrderProductCell: UITableViewCell {
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelProduct: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelSaleAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        LogPrint("orderDetailProductCell")
    }
    
    func addDiscountList(count: Int) {
        
        let optionName = GlobalShareManager.shared().optionName
        let optionAmount = GlobalShareManager.shared().optionAmount
        
        let labelProductArea = labelProduct.safeAreaLayoutGuide
        let labelAmountArea = labelSaleAmount.safeAreaLayoutGuide
        
        for i in stride(from: 0, to: count, by: 1) {
            
            let constant: CGFloat = CGFloat(5 + (7 * i) + (17 * i))
            
            let imageOption = UIImageView()
            imageOption.image = UIImage(named: "order_detail_extension")
            viewContent.addSubview(imageOption)
            
            imageOption.leadingAnchor.constraint(equalTo: labelProductArea.leadingAnchor, constant: 0).isActive = true
            imageOption.topAnchor.constraint(equalTo: labelProductArea.bottomAnchor, constant: constant + 5).isActive = true
            imageOption.translatesAutoresizingMaskIntoConstraints = false
            
            let labelOptionName = UILabel()
            viewContent.addSubview(labelOptionName)
            
            labelOptionName.text = optionName[i]
            labelOptionName.font = UIFont(name:"Roboto", size:CGFloat(16))
            labelOptionName.leadingAnchor.constraint(equalTo: labelProductArea.leadingAnchor, constant: 13).isActive = true
            labelOptionName.topAnchor.constraint(equalTo: labelProductArea.bottomAnchor, constant: constant).isActive = true
            labelOptionName.translatesAutoresizingMaskIntoConstraints = false
            
            let labelOptionAmount = UILabel()
            viewContent.addSubview(labelOptionAmount)
            
            labelOptionAmount.text = optionAmount[i]
            labelOptionAmount.font = UIFont(name:"Roboto", size:CGFloat(16))
            labelOptionAmount.trailingAnchor.constraint(equalTo: labelAmountArea.trailingAnchor, constant: 0).isActive = true
            labelOptionAmount.topAnchor.constraint(equalTo: labelProductArea.bottomAnchor, constant: constant).isActive = true
            labelOptionAmount.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
