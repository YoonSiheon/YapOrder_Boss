//
//  JsonData.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/10.
//

import Foundation
import UIKit
import SwiftyJSON

struct homeDailySalesData: Codable {
    var saleDtm: String?
    var saleCount: Int64?
    var saleAmount: Int64?
    var weekType: String?
    var dayCd: Int64?
    var dayNm: String?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.saleDtm = json["saleDtm"]?.string ?? ""
        self.saleCount = json["saleCount"]?.int64 ?? 0
        self.saleAmount = json["saleAmount"]?.int64 ?? 0
        self.weekType = json["weekType"]?.string ?? ""
        self.dayCd = json["dayCd"]?.int64 ?? 0
        self.dayNm = json["dayNm"]?.string ?? ""
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

struct homeFavoriteData: Codable {
    var saleAmt: Int64?
    var saleQty: Int64?
    var gdsNm: String?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.saleAmt = json["saleAmt"]?.int64 ?? 0
        self.saleQty = json["saleQty"]?.int64 ?? 0
        self.gdsNm = json["gdsNm"]?.string ?? ""
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

struct orderReceiptData: Codable {
    var orderId: Int64?
    var saleId: Int64?
    var orderNo: String?
    var orderStatus: String?
    var orderStatusName: String?
    
    var nextOrderStatus: String?
    var nextOrderStatusName: String?
    var waitNo: String?
    var tableNo: String?
    var tableName: String?
    
    var tableGroupName: String?
    var orderType: String?
    var orderTypeName: String?
    var isReservation: Bool?
    var orderTime: String?
    
    var payTime: String?
    var cancelTime: String?
    var reservationTime: String?
    var reservationPersonCount: Int64?
    var memberName: String?
    
    var memberPhone: String?
    var productName: String?
    var productCount: Int64?
    var saleAmount: Int64?
    var discountAmount: Int64?
    
    var couponAmount: Int64?
    var pointAmount: Int64?
    var payAmount: Int64?
    var memo: String?
    var paymentMethodName: String?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.orderId = json["orderId"]?.int64 ?? 0
        self.saleId = json["saleId"]?.int64 ?? 0
        self.orderNo = json["orderNo"]?.string ?? ""
        self.orderStatus = json["orderStatus"]?.string ?? ""
        self.orderStatusName = json["orderStatusName"]?.string ?? ""
        
        self.nextOrderStatus = json["nextOrderStatus"]?.string ?? ""
        self.nextOrderStatusName = json["nextOrderStatusName"]?.string ?? ""
        self.waitNo = json["waitNo"]?.string ?? ""
        self.tableNo = json["tableNo"]?.string ?? ""
        self.tableName = json["tableName"]?.string ?? ""
        
        self.tableGroupName = json["tableGroupName"]?.string ?? ""
        self.orderType = json["orderType"]?.string ?? ""
        self.orderTypeName = json["orderTypeName"]?.string ?? ""
        self.isReservation = json["isReservation"]?.bool ?? false
        self.orderTime = json["orderTime"]?.string ?? ""
        
        self.payTime = json["payTime"]?.string ?? ""
        self.cancelTime = json["cancelTime"]?.string ?? ""
        self.reservationTime = json["reservationTime"]?.string ?? ""
        self.reservationPersonCount = json["reservationPersonCount"]?.int64 ?? 0
        self.memberName = json["memberName"]?.string ?? ""
        
        self.memberPhone = json["memberPhone"]?.string ?? ""
        self.productName = json["productName"]?.string ?? ""
        self.productCount = json["productCount"]?.int64 ?? 0
        self.saleAmount = json["saleAmount"]?.int64 ?? 0
        self.discountAmount = json["discountAmount"]?.int64 ?? 0
        
        self.couponAmount = json["couponAmount"]?.int64 ?? 0
        self.pointAmount = json["pointAmount"]?.int64 ?? 0
        self.payAmount = json["payAmount"]?.int64 ?? 0
        self.memo = json["memo"]?.string ?? ""
        self.paymentMethodName = json["paymentMethodName"]?.string ?? ""
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

struct orderDiscountListData: Codable {
    var orderId: Int64?
    var seq: Int64?
    var productCode: String?
    var productName: String?
    var targetAmount: Int64?
    var quantity: Int64?
    var discountCode: String?
    var discountName: String?
    var discountType: String?
    var discountAmount: Int64?
    var discountApplyAmount: Int64?
    var discountCheck: String?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.orderId = json["orderId"]?.int64 ?? 0
        self.seq = json["seq"]?.int64 ?? 0
        self.productCode = json["productCode"]?.string ?? ""
        self.productName = json["productName"]?.string ?? ""
        self.targetAmount = json["targetAmount"]?.int64 ?? 0
        self.quantity = json["quantity"]?.int64 ?? 0
        self.discountCode = json["discountCode"]?.string ?? ""
        self.discountName = json["discountName"]?.string ?? ""
        self.discountType = json["discountType"]?.string ?? ""
        self.discountAmount = json["discountAmount"]?.int64 ?? 0
        self.discountApplyAmount = json["discountApplyAmount"]?.int64 ?? 0
        self.discountCheck = json["discountCheck"]?.string ?? ""
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

struct orderProductListData: Codable {
    var orderId: Int64?
    var orderSeq: Int64?
    var productCode: String?
    var productName: String?
    var orderTime: String?
    var salePrice: Int64?
    var saleQuantity: Int64?
    var saleAmount: Int64?
    var discountAmount: Int64?
    var realSaleAmount: Int64?
    var memo: String?
    var optionList: [JSON]?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.orderId = json["orderId"]?.int64 ?? 0
        self.orderSeq = json["orderSeq"]?.int64 ?? 0
        self.productCode = json["productCode"]?.string ?? ""
        self.productName = json["productName"]?.string ?? ""
        self.orderTime = json["orderTime"]?.string ?? ""
        self.salePrice = json["salePrice"]?.int64 ?? 0
        self.saleQuantity = json["saleQuantity"]?.int64 ?? 0
        self.saleAmount = json["saleAmount"]?.int64 ?? 0
        self.discountAmount = json["discountAmount"]?.int64 ?? 0
        self.realSaleAmount = json["realSaleAmount"]?.int64 ?? 0
        self.memo = json["memo"]?.string ?? ""
        self.optionList = json["optionList"]?.array ?? []
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

struct orderCancelReasonData: Codable {
    var cancelReasonType: String?
    var cancelReason: String?
    
    init(_ json: [String: JSON]?) {
        let json = json ?? [:]
        self.cancelReasonType = json["cancelReasonType"]?.string ?? ""
        self.cancelReason = json["cancelReason"]?.string ?? ""
    }
    
    init(_ json: JSON?) {
        self.init(json?.dictionaryValue)
    }
}

extension homeDailySalesData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(saleDtm)
        hasher.combine(saleCount)
        hasher.combine(saleAmount)
        hasher.combine(weekType)
        hasher.combine(dayCd)
        hasher.combine(dayNm)
    }
}

extension homeFavoriteData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(saleAmt)
        hasher.combine(saleQty)
        hasher.combine(gdsNm)
    }
}

extension orderReceiptData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
        hasher.combine(saleId)
        hasher.combine(orderNo)
        hasher.combine(orderStatus)
        hasher.combine(orderStatusName)
        
        hasher.combine(nextOrderStatus)
        hasher.combine(nextOrderStatusName)
        hasher.combine(waitNo)
        hasher.combine(tableNo)
        hasher.combine(tableName)
        
        hasher.combine(tableGroupName)
        hasher.combine(orderType)
        hasher.combine(orderTypeName)
        hasher.combine(isReservation)
        hasher.combine(orderTime)
        
        hasher.combine(payTime)
        hasher.combine(cancelTime)
        hasher.combine(reservationTime)
        hasher.combine(reservationPersonCount)
        hasher.combine(memberName)
        
        hasher.combine(memberPhone)
        hasher.combine(productName)
        hasher.combine(productCount)
        hasher.combine(saleAmount)
        hasher.combine(discountAmount)
        
        hasher.combine(couponAmount)
        hasher.combine(pointAmount)
        hasher.combine(payAmount)
        hasher.combine(memo)
        hasher.combine(paymentMethodName)
    }
}

extension orderDiscountListData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
        hasher.combine(seq)
        hasher.combine(productCode)
        hasher.combine(productName)
        hasher.combine(targetAmount)
        hasher.combine(quantity)
        hasher.combine(discountCode)
        hasher.combine(discountName)
        hasher.combine(discountType)
        hasher.combine(discountAmount)
        hasher.combine(discountApplyAmount)
    }
}

extension orderProductListData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
        hasher.combine(orderSeq)
        hasher.combine(productCode)
        hasher.combine(productName)
        hasher.combine(orderTime)
        hasher.combine(salePrice)
        hasher.combine(saleQuantity)
        hasher.combine(saleAmount)
        hasher.combine(discountAmount)
        hasher.combine(realSaleAmount)
        hasher.combine(memo)
//        hasher.combine(optionList)
    }
}

extension orderCancelReasonData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(cancelReasonType)
        hasher.combine(cancelReason)
    }
}
