//
//  OrderCategoryCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/16.
//

import Foundation
import UIKit

class OrderCategoryCell: UITableViewCell {

    @IBOutlet weak var viewOrderWaiting: UIView!
    @IBOutlet weak var labelOrderWaiting: UILabel!
    @IBOutlet weak var viewOrderProcessing: UIView!
    @IBOutlet weak var labelOrdeProcessing: UILabel!
    @IBOutlet weak var viewOrderComplete: UIView!
    @IBOutlet weak var labelOrderComplete: UILabel!
    @IBOutlet weak var viewOrderCancel: UIView!
    @IBOutlet weak var labelOrderCancel: UILabel!
    
    var selectOrderType: Int = TAB_ORDER_ORDERWAITING
    
    var orderWaitingCount: String = ""
    var orderProcessingCount: String = ""
    var orderCompleteCount: String = ""
    var orderCancelCount: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        LogPrint("OrderCategoryCell")
        
        labelOrderWaiting.text = "order_orderwaiting".localized() + orderWaitingCount
        labelOrdeProcessing.text = "order_orderprocessing".localized() + orderProcessingCount
        labelOrderComplete.text = "order_ordercomplete".localized() + orderCompleteCount
        labelOrderCancel.text = "order_ordercancel".localized() + orderCancelCount
        
        viewOrderWaiting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderWaiting)))
        viewOrderProcessing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderProcessing)))
        viewOrderComplete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderComplete)))
        viewOrderCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchOrderCancel)))
        
        viewOrderWaiting.backgroundColor = COMMON_BLACK
        labelOrderWaiting.textColor = COMMON_WHITE
        
        viewOrderProcessing.backgroundColor = COMMON_WHITE
        labelOrdeProcessing.textColor = COMMON_BLACK
        viewOrderComplete.backgroundColor = COMMON_WHITE
        labelOrderComplete.textColor = COMMON_BLACK
        viewOrderCancel.backgroundColor = COMMON_WHITE
        labelOrderCancel.textColor = COMMON_BLACK
    }
    
    func initCategory(select: Int) {
        
        orderWaitingCount = String(GlobalShareManager.shared().order_countOrder)
        orderProcessingCount = String(GlobalShareManager.shared().order_countING)
        orderCompleteCount = String(GlobalShareManager.shared().order_countComplete)
        orderCancelCount = String(GlobalShareManager.shared().order_countCancel)
        
        labelOrderWaiting.text = "order_orderwaiting".localized() + " " + orderWaitingCount
        labelOrdeProcessing.text = "order_orderprocessing".localized() + " " + orderProcessingCount
        labelOrderComplete.text = "order_ordercomplete".localized() + " " + orderCompleteCount
        labelOrderCancel.text = "order_ordercancel".localized() + " " + orderCancelCount
        
        setCategoryButton(select: select)
    }
    
    func setCategoryButton(select: Int) {
        
        if select == TAB_ORDER_ORDERWAITING {
            
            selectOrderType = TAB_ORDER_ORDERWAITING
            
            viewOrderWaiting.backgroundColor = COMMON_BLACK
            labelOrderWaiting.textColor = COMMON_WHITE
            
            viewOrderProcessing.backgroundColor = COMMON_WHITE
            labelOrdeProcessing.textColor = COMMON_BLACK
            viewOrderComplete.backgroundColor = COMMON_WHITE
            labelOrderComplete.textColor = COMMON_BLACK
            viewOrderCancel.backgroundColor = COMMON_WHITE
            labelOrderCancel.textColor = COMMON_BLACK
            
        } else if select == TAB_ORDER_ORDERPROCESSING {
            
            selectOrderType = TAB_ORDER_ORDERPROCESSING
            
            viewOrderWaiting.backgroundColor = COMMON_WHITE
            labelOrderWaiting.textColor = COMMON_BLACK
            
            viewOrderProcessing.backgroundColor = COMMON_BLACK
            labelOrdeProcessing.textColor = COMMON_WHITE
            
            viewOrderComplete.backgroundColor = COMMON_WHITE
            labelOrderComplete.textColor = COMMON_BLACK
            viewOrderCancel.backgroundColor = COMMON_WHITE
            labelOrderCancel.textColor = COMMON_BLACK
            
        } else if select == TAB_ORDER_ORDERCOMPLETE {
            
            selectOrderType = TAB_ORDER_ORDERCOMPLETE
            
            viewOrderWaiting.backgroundColor = COMMON_WHITE
            labelOrderWaiting.textColor = COMMON_BLACK
            viewOrderProcessing.backgroundColor = COMMON_WHITE
            labelOrdeProcessing.textColor = COMMON_BLACK
            
            viewOrderComplete.backgroundColor = COMMON_BLACK
            labelOrderComplete.textColor = COMMON_WHITE
            
            viewOrderCancel.backgroundColor = COMMON_WHITE
            labelOrderCancel.textColor = COMMON_BLACK
            
        } else if select == TAB_ORDER_ORDERCANCEL {
            
            selectOrderType = TAB_ORDER_ORDERCANCEL
            
            viewOrderWaiting.backgroundColor = COMMON_WHITE
            labelOrderWaiting.textColor = COMMON_BLACK
            viewOrderProcessing.backgroundColor = COMMON_WHITE
            labelOrdeProcessing.textColor = COMMON_BLACK
            viewOrderComplete.backgroundColor = COMMON_WHITE
            labelOrderComplete.textColor = COMMON_BLACK
            
            viewOrderCancel.backgroundColor = COMMON_BLACK
            labelOrderCancel.textColor = COMMON_WHITE
        }
        
    }
    
    @objc func touchOrderWaiting(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderWaiting")
        
        setCategoryButton(select: TAB_ORDER_ORDERWAITING)
        
        NotificationCenter.default.post(name: NSNotification.Name("callOrderWaitting"), object: nil, userInfo: nil)
    }
    
    @objc func touchOrderProcessing(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderProcessing")
        
        setCategoryButton(select: TAB_ORDER_ORDERPROCESSING)
        
        NotificationCenter.default.post(name: NSNotification.Name("callOrderING"), object: nil, userInfo: nil)
    }
    
    @objc func touchOrderComplete(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderComplete")
        
        setCategoryButton(select: TAB_ORDER_ORDERCOMPLETE)
        
        NotificationCenter.default.post(name: NSNotification.Name("callOrderComplete"), object: nil, userInfo: nil)
    }
    
    @objc func touchOrderCancel(sender: UITapGestureRecognizer) {
        LogPrint("touchOrderCancel")
        
        setCategoryButton(select: TAB_ORDER_ORDERCANCEL)
        
        NotificationCenter.default.post(name: NSNotification.Name("callOrderCancel"), object: nil, userInfo: nil)
    }
    
}
