//
//  HomeViewHolder.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/03/06.
//

import Foundation
import Alamofire
import SwiftyJSON

extension HomeViewController {
    
    //************************************************************************************************************************//
    
    func updateSalesStop(bizStop: String) {
        
        if bizStop == "Y" {
            
            switchSalesClosed.setOn(true, animated: false)
            labelSwitchDescription.text = "home_storestop_on".localized()
            
        } else {
            
            switchSalesClosed.setOn(false, animated: false)
            labelSwitchDescription.text = "home_storestop_off".localized()
        }
    }
    
    func updateOrderData() {
        
        GlobalShareManager.shared().order_countOrder = 0
        GlobalShareManager.shared().order_countING = 0
        GlobalShareManager.shared().order_countComplete = 0
        GlobalShareManager.shared().order_countCancel = 0
        
        let homeOrderArray = GlobalShareManager.shared().homeOrderArray
        
        GlobalShareManager.shared().order_countOrder = homeOrderArray["receiptCount"] as? Int ?? 0
        GlobalShareManager.shared().order_countING = homeOrderArray["progressCount"] as? Int ?? 0
        GlobalShareManager.shared().order_countComplete = homeOrderArray["completeCount"] as? Int ?? 0
        GlobalShareManager.shared().order_countCancel = homeOrderArray["cancelCount"] as? Int ?? 0
        
        if GlobalShareManager.shared().order_countOrder > 0 {
            labelOrderWaitingCount.textColor = COMMON_ORANGE
            labelOrderWaitingTitle.textColor = COMMON_ORANGE
        } else {
            labelOrderWaitingCount.textColor = COMMON_BLACK
            labelOrderWaitingTitle.textColor = COMMON_BLACK
        }
        
        labelOrderWaitingCount.text = String(GlobalShareManager.shared().order_countOrder)
        labelProcessingCount.text = String(GlobalShareManager.shared().order_countING)
        labelCompleteCount.text = String(GlobalShareManager.shared().order_countComplete)
        labelCancelCount.text = String(GlobalShareManager.shared().order_countCancel)
        
        let todayAmount = homeOrderArray["todayAmount"] as? Int ?? 0
        let yesterdayAmount = homeOrderArray["yesterdayAmount"] as? Int ?? 0
        let lastWeekAmount = homeOrderArray["lastWeekdayAmount"] as? Int ?? 0
        
        labelTodaySales.text = String(todayAmount.toComma()) + "home_sales_amount".localized()
        labelYesterdatSlaes.text = "home_sales_yesterday".localized() + " " + String(yesterdayAmount.toComma()) + "home_sales_amount".localized()
        labelLastWeekSales.text = "home_sales_lastweek".localized() + " " + String(lastWeekAmount.toComma()) + "home_sales_amount".localized()
    }
    
    func updateGraphData(graphAni: Bool = false, weekSelect: Int, daySelect: Int) {
        
        LogPrint("week:\(weekSelect), day:\(daySelect)")
        
        if test_data == 0 {
            
            var week = Dictionary<String, Any>()
            var weekDailySales = Array<homeDailySalesData>()
            var startDate: String = ""
            var endDate: String = ""
            
            if weekSelect == 0 {    // 지난주
                
                week = GlobalShareManager.shared().homeLastWeekArray
                weekDailySales = GlobalShareManager.shared().homeLastWeekDailySalesArray
                
                startDate = week["startDtm"] as? String ?? ""
                endDate = week["endDtm"] as? String ?? ""
                
                dayAmount = Int(weekDailySales[daySelect].saleAmount ?? 0)
                
            } else if weekSelect == 1 {            // 이번주
                
                week = GlobalShareManager.shared().homeThisWeekArray
                weekDailySales = GlobalShareManager.shared().homeThisWeekDailySalesArray
                
                startDate = week["startDtm"] as? String ?? ""
                endDate = week["endDtm"] as? String ?? ""
                
                dayAmount = Int(weekDailySales[daySelect].saleAmount ?? 0)
            }
            
            startDate = startDate + "000000"
            endDate = endDate + "235959"
            
            viewSalesDate.text = nowDate(type: "8", toDate: startDate) + " - " + nowDate(type: "8", toDate: endDate)
            labelWeekAmount.text = String(dayAmount.toComma()) + "home_sales_amount".localized()
            labelBalloonAmount.text = String(dayAmount.toComma()) + "home_sales_amount".localized()
            
            //**********************************************************************//
            
            // 요일 카운트로 정렬(일, 월, ... , 금, 토)
            let tempSortArray = weekDailySales.sorted(by: {JSON(rawValue: $0.dayCd as Any) ?? 0 < JSON(rawValue: $1.dayCd as Any) ?? 0})
            //LogPrint(tempSortArray)
            
            // ysh 최고 매출을 찾기 위한 배열(차후 수정-배열을 이용하는게 아닌 바로 제일큰 값이 나오도록)
            let tempMaxAmountArray = weekDailySales.sorted(by: {JSON(rawValue: $0.saleAmount as Any) ?? 0 > JSON(rawValue: $1.saleAmount as Any) ?? 0})
            //LogPrint(tempMaxAmountArray[0].saleAmount)
            
            var maxAmount: Int = 0
            if tempMaxAmountArray[0].saleAmount ?? 0 <= 10000 {
                maxAmount = 10000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 50000 {
                maxAmount = 50000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 100000 {
                maxAmount = 100000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 200000 {
                maxAmount = 200000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 300000 {
                maxAmount = 300000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 400000 {
                maxAmount = 400000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 500000 {
                maxAmount = 500000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 600000 {
                maxAmount = 600000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 700000 {
                maxAmount = 700000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 800000 {
                maxAmount = 800000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 900000 {
                maxAmount = 900000
            } else if tempMaxAmountArray[0].saleAmount ?? 0 <= 1000000 {
                maxAmount = 1000000
            }
            
            // 최고매출 대비 그래프값을 위한 정렬
            var tempScalArray: [Float] = []
            for i in stride(from: 0, to: tempSortArray.count, by: 1) {
                
                let tempScal = Float(tempSortArray[i].saleAmount ?? 0) / Float(maxAmount)
                //LogPrint(tempScal)
                
                tempScalArray.append( 0.2 + (0.08 * (tempScal * 10)) )
                //LogPrint(tempScalArray[i])
            }
            
            // 초기 세팅시 애니메이션 보여줌
            if graphAni {
                bar1.setProgress(tempScalArray[1], animated: true)
                bar2.setProgress(tempScalArray[2], animated: true)
                bar3.setProgress(tempScalArray[3], animated: true)
                bar4.setProgress(tempScalArray[4], animated: true)
                bar5.setProgress(tempScalArray[5], animated: true)
                bar6.setProgress(tempScalArray[6], animated: true)
                bar7.setProgress(tempScalArray[0], animated: true)
            }
            
            let tempBalloon = labelBalloonAmount.text!.count > 7 ? 10 : 20
            
            changeWeekDay(balloon: tempBalloon, select: daySelect, graphValue: tempScalArray)
            
            
        }
        else {
            
            var week = Dictionary<String, Any>()
            var weekDailySales = [[[String(), (Any).self]]]
            var startDate: String = ""
            var endDate: String = ""
            
            if weekSelect == 0 {    // 지난주
                
                week = GlobalShareManager.shared().homeLastWeekArray
                
                weekDailySales = [ [ ["saleDtm" , 20230213], ["saleCount", 0], ["saleAmount", 30000], ["weekType", "lastWeek"], ["dayCd", 2], ["dayNm", "월"] ]
                                       ,[ ["saleDtm" , 20230214], ["saleCount", 0], ["saleAmount", 10000], ["weekType", "lastWeek"], ["dayCd", 3], ["dayNm", "화"] ]
                                       ,[ ["saleDtm" , 20230215], ["saleCount", 0], ["saleAmount", 40000], ["weekType", "lastWeek"], ["dayCd", 4], ["dayNm", "수"] ]
                                       ,[ ["saleDtm" , 20230216], ["saleCount", 0], ["saleAmount", 90000], ["weekType", "lastWeek"], ["dayCd", 5], ["dayNm", "목"] ]
                                       ,[ ["saleDtm" , 20230217], ["saleCount", 0], ["saleAmount", 70000], ["weekType", "lastWeek"], ["dayCd", 6], ["dayNm", "금"] ]
                                       ,[ ["saleDtm" , 20230218], ["saleCount", 0], ["saleAmount", 10000], ["weekType", "lastWeek"], ["dayCd", 7], ["dayNm", "토"] ]
                                       ,[ ["saleDtm" , 20230212], ["saleCount", 0], ["saleAmount", 5000], ["weekType", "lastWeek"], ["dayCd", 1], ["dayNm", "일"] ] ]
                
                startDate = week["startDtm"] as? String ?? ""
                endDate = week["endDtm"] as? String ?? ""
                
                dayAmount = weekDailySales[daySelect][2][1] as? Int ?? 0
                
            } else if weekSelect == 1 {            // 이번주
                
                week = GlobalShareManager.shared().homeThisWeekArray
                
                weekDailySales = [ [ ["saleDtm" , 20230220], ["saleCount", 0], ["saleAmount", 70000], ["weekType", "lastWeek"], ["dayCd", 2], ["dayNm", "월"] ]
                                       ,[ ["saleDtm" , 20230221], ["saleCount", 0], ["saleAmount", 220000], ["weekType", "lastWeek"], ["dayCd", 3], ["dayNm", "화"] ]
                                       ,[ ["saleDtm" , 20230222], ["saleCount", 0], ["saleAmount", 30000], ["weekType", "lastWeek"], ["dayCd", 4], ["dayNm", "수"] ]
                                       ,[ ["saleDtm" , 20230223], ["saleCount", 0], ["saleAmount", 60000], ["weekType", "lastWeek"], ["dayCd", 5], ["dayNm", "목"] ]
                                       ,[ ["saleDtm" , 20230224], ["saleCount", 0], ["saleAmount", 10000], ["weekType", "lastWeek"], ["dayCd", 6], ["dayNm", "금"] ]
                                       ,[ ["saleDtm" , 20230225], ["saleCount", 0], ["saleAmount", 0], ["weekType", "lastWeek"], ["dayCd", 7], ["dayNm", "토"] ]
                                       ,[ ["saleDtm" , 20230219], ["saleCount", 0], ["saleAmount", 0], ["weekType", "lastWeek"], ["dayCd", 1], ["dayNm", "일"] ] ]
                
                startDate = week["startDtm"] as? String ?? ""
                endDate = week["endDtm"] as? String ?? ""
                
                dayAmount = weekDailySales[daySelect][2][1] as? Int ?? 0
            }
            
            startDate = startDate + "000000"
            endDate = endDate + "235959"
            
            viewSalesDate.text = nowDate(type: "8", toDate: startDate) + " - " + nowDate(type: "8", toDate: endDate)
            labelWeekAmount.text = String(dayAmount.toComma()) + "home_sales_amount".localized()
            labelBalloonAmount.text = String(dayAmount.toComma()) + "home_sales_amount".localized()
            
            //**********************************************************************//
            
            // 요일 카운트로 정렬(일, 월, ... , 금, 토)
            let tempSortArray = weekDailySales.sorted(by: {JSON(rawValue: $0[4][1] as Any) ?? 0 < JSON(rawValue: $1[4][1] as Any) ?? 0})
            //LogPrint(tempSortArray)
            
            // 최고 매출을 찾기 위한 배열
            let tempMaxAmountArray = weekDailySales.sorted(by: {JSON(rawValue: $0[2][1] as Any) ?? 0 > JSON(rawValue: $1[2][1] as Any) ?? 0})
            LogPrint("최고매출액:\(tempMaxAmountArray[0][2][1])")
            
            var maxAmount: Int = 0
            if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 10000 {
                maxAmount = 10000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 50000 {
                maxAmount = 50000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 100000 {
                maxAmount = 100000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 200000 {
                maxAmount = 200000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 300000 {
                maxAmount = 300000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 400000 {
                maxAmount = 400000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 500000 {
                maxAmount = 500000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 600000 {
                maxAmount = 600000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 700000 {
                maxAmount = 700000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 800000 {
                maxAmount = 800000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 900000 {
                maxAmount = 900000
            } else if tempMaxAmountArray[0][2][1] as? Int ?? 0 <= 1000000 {
                maxAmount = 1000000
            }
            
            // 최고매출 대비 그래프값을 위한 정렬
            var tempScalArray: [Float] = []
            for i in stride(from: 0, to: tempSortArray.count, by: 1) {
                
                let tempScal = Float(tempSortArray[i][2][1] as? Int ?? 0) / Float(maxAmount)
                //LogPrint(tempScal)
                
                tempScalArray.append( 0.2 + (0.08 * (tempScal * 10)) )
                //LogPrint(tempScalArray[i])
            }
            
            // 초기 세팅시 애니메이션 보여줌
            if graphAni {
                bar1.setProgress(tempScalArray[1], animated: true)
                bar2.setProgress(tempScalArray[2], animated: true)
                bar3.setProgress(tempScalArray[3], animated: true)
                bar4.setProgress(tempScalArray[4], animated: true)
                bar5.setProgress(tempScalArray[5], animated: true)
                bar6.setProgress(tempScalArray[6], animated: true)
                bar7.setProgress(tempScalArray[0], animated: true)
            }
            
            let tempBalloon = labelBalloonAmount.text!.count > 7 ? 10 : 20
            
            changeWeekDay(balloon: tempBalloon, select: daySelect, graphValue: tempScalArray)
        }
        
    }
    
    func updateFavoriteData() {
        
        if test_data == 0 {
            
            let orderFavoriteArray = GlobalShareManager.shared().homeFavoriteArray
            
            let tempSortArray = orderFavoriteArray.sorted(by: {JSON(rawValue: $0.saleQty as Any) ?? 0 > JSON(rawValue: $1.saleQty as Any) ?? 0})
            //LogPrint(tempSortArray)
            
            //*****************************************************************************//
            
            if orderFavoriteArray.count == 0 {
                labelFavoriteNone.isHidden = false
                labelFavoriteNone.text = "home_favorite_none".localized()
                favoriteViewHeight.constant = FAVORITE_HEIGHT[0]
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[1] - FAVORITE_HEIGHT[0])
                
                labelFavoriteNumber1.isHidden = true
                labelFavoriteNumber1Menu.isHidden = true
                labelFavoriteNumber1Price.isHidden = true
                labelFavoriteNumber1Count.isHidden = true
                labelFavoriteNumber2.isHidden = true
                labelFavoriteNumber2Menu.isHidden = true
                labelFavoriteNumber2Price.isHidden = true
                labelFavoriteNumber2Count.isHidden = true
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
            } else if orderFavoriteArray.count == 1 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = true
                labelFavoriteNumber2Menu.isHidden = true
                labelFavoriteNumber2Price.isHidden = true
                labelFavoriteNumber2Count.isHidden = true
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0].gdsNm ?? ""
                labelFavoriteNumber1Price.text = String(Int(tempSortArray[0].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(Int(tempSortArray[0].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 2 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0].gdsNm ?? ""
                labelFavoriteNumber1Price.text = String(Int(tempSortArray[0].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(Int(tempSortArray[0].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1].gdsNm ?? ""
                labelFavoriteNumber2Price.text = String(Int(tempSortArray[1].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(Int(tempSortArray[1].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 3 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0].gdsNm ?? ""
                labelFavoriteNumber1Price.text = String(Int(tempSortArray[0].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(Int(tempSortArray[0].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1].gdsNm ?? ""
                labelFavoriteNumber2Price.text = String(Int(tempSortArray[1].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(Int(tempSortArray[1].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2].gdsNm ?? ""
                labelFavoriteNumber3Price.text = String(Int(tempSortArray[2].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(Int(tempSortArray[2].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 4 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = false
                labelFavoriteNumber4Menu.isHidden = false
                labelFavoriteNumber4Price.isHidden = false
                labelFavoriteNumber4Count.isHidden = false
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0].gdsNm ?? ""
                labelFavoriteNumber1Price.text = String(Int(tempSortArray[0].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(Int(tempSortArray[0].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1].gdsNm ?? ""
                labelFavoriteNumber2Price.text = String(Int(tempSortArray[1].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(Int(tempSortArray[1].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2].gdsNm ?? ""
                labelFavoriteNumber3Price.text = String(Int(tempSortArray[2].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(Int(tempSortArray[2].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber4Menu.text = tempSortArray[3].gdsNm ?? ""
                labelFavoriteNumber4Price.text = String(Int(tempSortArray[3].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber4Count.text = String(Int(tempSortArray[3].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 5 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = false
                labelFavoriteNumber4Menu.isHidden = false
                labelFavoriteNumber4Price.isHidden = false
                labelFavoriteNumber4Count.isHidden = false
                labelFavoriteNumber5.isHidden = false
                labelFavoriteNumber5Menu.isHidden = false
                labelFavoriteNumber5Price.isHidden = false
                labelFavoriteNumber5Count.isHidden = false
                
                labelFavoriteNumber1Menu.text = tempSortArray[0].gdsNm ?? ""
                labelFavoriteNumber1Price.text = String(Int(tempSortArray[0].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(Int(tempSortArray[0].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1].gdsNm ?? ""
                labelFavoriteNumber2Price.text = String(Int(tempSortArray[1].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(Int(tempSortArray[1].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2].gdsNm ?? ""
                labelFavoriteNumber3Price.text = String(Int(tempSortArray[2].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(Int(tempSortArray[2].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber4Menu.text = tempSortArray[3].gdsNm ?? ""
                labelFavoriteNumber4Price.text = String(Int(tempSortArray[3].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber4Count.text = String(Int(tempSortArray[3].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
                labelFavoriteNumber5Menu.text = tempSortArray[4].gdsNm ?? ""
                labelFavoriteNumber5Price.text = String(Int(tempSortArray[4].saleAmt ?? 0).toComma()) + "home_favorite_amount".localized()
                labelFavoriteNumber5Count.text = String(Int(tempSortArray[4].saleQty ?? 0).toComma()) + "home_favorite_quantity".localized()
            }
        } else {
            
            let orderFavoriteArray = [ [ ["saleAmt" , 3500], ["saleQty", 25], ["gdsNm", "아메리카노1111"] ]
                                        ,[ ["saleAmt" , 2500], ["saleQty", 15], ["gdsNm", "아메리카노2222"] ]
                                        ,[ ["saleAmt" , 4500], ["saleQty", 35], ["gdsNm", "아메리카노3333"] ]
                                        ,[ ["saleAmt" , 1500], ["saleQty", 85], ["gdsNm", "아메리카노4444"] ]
                                        ,[ ["saleAmt" , 7500], ["saleQty", 15], ["gdsNm", "아메리카노5555"] ]
            ]
            
            let tempSortArray = orderFavoriteArray.sorted(by: {JSON(rawValue: $0[1][1]) ?? 0 > JSON(rawValue: $1[1][1]) ?? 0})
            //LogPrint(tempSortArray)
            
            if orderFavoriteArray.count == 0 {
                labelFavoriteNone.isHidden = false
                labelFavoriteNone.text = "home_favorite_none".localized()
                favoriteViewHeight.constant = FAVORITE_HEIGHT[0]
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[1] - FAVORITE_HEIGHT[0])
                
                labelFavoriteNumber1.isHidden = true
                labelFavoriteNumber1Menu.isHidden = true
                labelFavoriteNumber1Price.isHidden = true
                labelFavoriteNumber1Count.isHidden = true
                labelFavoriteNumber2.isHidden = true
                labelFavoriteNumber2Menu.isHidden = true
                labelFavoriteNumber2Price.isHidden = true
                labelFavoriteNumber2Count.isHidden = true
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
            } else if orderFavoriteArray.count == 1 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = true
                labelFavoriteNumber2Menu.isHidden = true
                labelFavoriteNumber2Price.isHidden = true
                labelFavoriteNumber2Count.isHidden = true
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0][2][1] as? String ?? ""
                labelFavoriteNumber1Price.text = String(tempSortArray[0][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(tempSortArray[0][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 2 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = true
                labelFavoriteNumber3Menu.isHidden = true
                labelFavoriteNumber3Price.isHidden = true
                labelFavoriteNumber3Count.isHidden = true
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0][2][1] as? String ?? ""
                labelFavoriteNumber1Price.text = String(tempSortArray[0][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(tempSortArray[0][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1][2][1] as? String ?? ""
                labelFavoriteNumber2Price.text = String(tempSortArray[1][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(tempSortArray[1][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 3 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = true
                labelFavoriteNumber4Menu.isHidden = true
                labelFavoriteNumber4Price.isHidden = true
                labelFavoriteNumber4Count.isHidden = true
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0][2][1] as? String ?? ""
                labelFavoriteNumber1Price.text = String(tempSortArray[0][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(tempSortArray[0][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1][2][1] as? String ?? ""
                labelFavoriteNumber2Price.text = String(tempSortArray[1][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(tempSortArray[1][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2][2][1] as? String ?? ""
                labelFavoriteNumber3Price.text = String(tempSortArray[2][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(tempSortArray[2][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 4 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = false
                labelFavoriteNumber4Menu.isHidden = false
                labelFavoriteNumber4Price.isHidden = false
                labelFavoriteNumber4Count.isHidden = false
                labelFavoriteNumber5.isHidden = true
                labelFavoriteNumber5Menu.isHidden = true
                labelFavoriteNumber5Price.isHidden = true
                labelFavoriteNumber5Count.isHidden = true
                
                labelFavoriteNumber1Menu.text = tempSortArray[0][2][1] as? String ?? ""
                labelFavoriteNumber1Price.text = String(tempSortArray[0][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(tempSortArray[0][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1][2][1] as? String ?? ""
                labelFavoriteNumber2Price.text = String(tempSortArray[1][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(tempSortArray[1][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2][2][1] as? String ?? ""
                labelFavoriteNumber3Price.text = String(tempSortArray[2][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(tempSortArray[2][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber4Menu.text = tempSortArray[3][2][1] as? String ?? ""
                labelFavoriteNumber4Price.text = String(tempSortArray[3][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber4Count.text = String(tempSortArray[3][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                
            } else if orderFavoriteArray.count == 5 {
                
                labelFavoriteNone.isHidden = true
                favoriteViewHeight.constant = 79 + (FAVORITE_HEIGHT[2] * CGFloat(orderFavoriteArray.count))
                scrollViewHeight.constant = heightScrollViewHeight - (FAVORITE_HEIGHT[2] * CGFloat((5 - orderFavoriteArray.count)))
                
                labelFavoriteNumber1.isHidden = false
                labelFavoriteNumber1Menu.isHidden = false
                labelFavoriteNumber1Price.isHidden = false
                labelFavoriteNumber1Count.isHidden = false
                labelFavoriteNumber2.isHidden = false
                labelFavoriteNumber2Menu.isHidden = false
                labelFavoriteNumber2Price.isHidden = false
                labelFavoriteNumber2Count.isHidden = false
                labelFavoriteNumber3.isHidden = false
                labelFavoriteNumber3Menu.isHidden = false
                labelFavoriteNumber3Price.isHidden = false
                labelFavoriteNumber3Count.isHidden = false
                labelFavoriteNumber4.isHidden = false
                labelFavoriteNumber4Menu.isHidden = false
                labelFavoriteNumber4Price.isHidden = false
                labelFavoriteNumber4Count.isHidden = false
                labelFavoriteNumber5.isHidden = false
                labelFavoriteNumber5Menu.isHidden = false
                labelFavoriteNumber5Price.isHidden = false
                labelFavoriteNumber5Count.isHidden = false
                
                labelFavoriteNumber1Menu.text = tempSortArray[0][2][1] as? String ?? ""
                labelFavoriteNumber1Price.text = String(tempSortArray[0][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber1Count.text = String(tempSortArray[0][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber2Menu.text = tempSortArray[1][2][1] as? String ?? ""
                labelFavoriteNumber2Price.text = String(tempSortArray[1][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber2Count.text = String(tempSortArray[1][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber3Menu.text = tempSortArray[2][2][1] as? String ?? ""
                labelFavoriteNumber3Price.text = String(tempSortArray[2][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber3Count.text = String(tempSortArray[2][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber4Menu.text = tempSortArray[3][2][1] as? String ?? ""
                labelFavoriteNumber4Price.text = String(tempSortArray[3][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber4Count.text = String(tempSortArray[3][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
                labelFavoriteNumber5Menu.text = tempSortArray[4][2][1] as? String ?? ""
                labelFavoriteNumber5Price.text = String(tempSortArray[4][0][1] as? Int ?? 0) + "home_favorite_amount".localized()
                labelFavoriteNumber5Count.text = String(tempSortArray[4][1][1] as? Int ?? 0) + "home_favorite_quantity".localized()
            }
        }
    }
    
    //************************************************************************************************************************//
    
    //스토어 정보 조회
    func getStore() {
        
        DispatchQueue.main.async {
            NetworkManager.shared().getStore(token: self.accessToken, storeCode: self.storeCode, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET store")
                        
                        var storeName = ""
                        if let completeData = data.value(forKey: "data") as? NSDictionary {
                            
                            storeName = completeData.value(forKey: "storeName") as? String ?? ""
                            
                            self.labelStoreName.text = storeName
                        }
                        
                    } else {
                        LogPrint("GET store FAIL")
                    }
                } else {
                    LogPrint("NETWORK FAIL - getStore")
                }
            })
        }
    }
    
    func getSalesStop(bizStop: String) {
        
        DispatchQueue.main.async {
            NetworkManager.shared().getSalesClosed(token: self.accessToken, storeCode: self.storeCode, bizStopYn: bizStop, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET bizstop")
                        
                        if let completeData = data.value(forKey: "data") as? NSDictionary {
                            
                            let bizYn = completeData.value(forKey: "bizStopYn") as? String ?? ""
                            
                            if bizYn == "Y" {
                                
                                showToast(selfView: self, message: "home_storestop_start".localized(), width: 240)
                                self.switchSalesClosed.setOn(true, animated: true)
                                self.labelSwitchDescription.text = "home_storestop_on".localized()
                                
                            } else if bizYn == "N" {
                                
                                showToast(selfView: self, message: "home_storestop_stop".localized(), width: 240)
                                self.switchSalesClosed.setOn(false, animated: true)
                                self.labelSwitchDescription.text = "home_storestop_off".localized()
                            }
                        }
                        
                    } else {
                        LogPrint("GET bizstop FAIL")
                    }
                } else {
                    LogPrint("NETWORK FAIL - getSalesClosed")
                }
            })
        }
    }
    
    // 조리시간
    func getCookInfo() {
        
        DispatchQueue.main.async {
            NetworkManager.shared().getCookTimeInfo(token: self.accessToken, storeCode: self.storeCode, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getCookTimeInfo")
                        
                        do {
                            let cookTimeInfoResult = data.value(forKey: "data") as? NSDictionary
                            
                            GlobalShareManager.shared().cookTimeType = cookTimeInfoResult!["cookTimeType"] as? String ?? ""
                            GlobalShareManager.shared().cookTimeTypeText = cookTimeInfoResult!["cookTimeTypeText"] as? String ?? ""
                            GlobalShareManager.shared().cookTimeMinute = cookTimeInfoResult!["minute"] as? Int ?? 0
                            GlobalShareManager.shared().orderEstimateTimeArray = cookTimeInfoResult!["selectable"] as? [Int] ?? [0]
                            LogPrint("cooktimeType:\(GlobalShareManager.shared().cookTimeType) - \(GlobalShareManager.shared().cookTimeTypeText)")
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET getCookTimeInfo FAIL")
                    }
                } else {
                    LogPrint("NETWORK FAIL - getCookTimeInfo")
                }
            })
        }
        
    }
    
    // 취소 사유
    func getCancelReason() {
        
        DispatchQueue.main.async {
            NetworkManager.shared().getCancelReason(token: self.accessToken, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET getCancelReason")
                        
                        do {
                            GlobalShareManager.shared().orderCancelReasonArray.removeAll()
                            
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let jsonResult = try JSON(data: jsonData)
                            
                            let orderCancelReasonResult = jsonResult["data"]
                            GlobalShareManager.shared().orderCancelReasonArray = orderCancelReasonResult.arrayValue.compactMap({orderCancelReasonData($0)})
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET CANCEL REASON FAIL")
                    }
                } else {
                    LogPrint("NETWORK FAIL - getStore")
                }
            })
        }
        
    }

    //home data - 매출, 그래프, 인기메뉴
    func getHomeData() {
        
        DispatchQueue.main.async {
            NetworkManager.shared().getHomeData(token: self.accessToken, storeCode: self.storeCode, completion: {(success, status, data) in
                if success {
                    if (status == 200) {
                        LogPrint("GET GETHOMEDATA")
                        
                        GlobalShareManager.shared().homeOrderArray.removeAll()
                        GlobalShareManager.shared().homeLastWeekArray.removeAll()
                        GlobalShareManager.shared().homeThisWeekArray.removeAll()
                        GlobalShareManager.shared().homeFavoriteArray.removeAll()
                        GlobalShareManager.shared().homeLastWeekDailySalesArray.removeAll()
                        GlobalShareManager.shared().homeThisWeekDailySalesArray.removeAll()
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            let jsonResult = try JSON(data: jsonData)
                            
                            let homeOrderResult = jsonResult["data"]
                            let homeLastWeekResult = homeOrderResult["lastWeekList"]
                            let homeThisWeekResult = homeOrderResult["thisWeekList"]
                            let homeFavoriteResult = homeOrderResult["dailySaleGdsList"]
                            let homeLastWeekDailySalesResult = homeLastWeekResult["dailySales"]
                            let homeThisWeekDailySalesResult = homeThisWeekResult["dailySales"]
                            
                            GlobalShareManager.shared().homeOrderArray = homeOrderResult.dictionaryObject!
                            GlobalShareManager.shared().homeLastWeekArray = homeLastWeekResult.dictionaryObject!
                            GlobalShareManager.shared().homeThisWeekArray = homeThisWeekResult.dictionaryObject!
                            GlobalShareManager.shared().homeFavoriteArray = homeFavoriteResult.arrayValue.compactMap({homeFavoriteData($0)})
                            GlobalShareManager.shared().homeLastWeekDailySalesArray = homeLastWeekDailySalesResult.arrayValue.compactMap({homeDailySalesData($0)})
                            GlobalShareManager.shared().homeThisWeekDailySalesArray = homeThisWeekDailySalesResult.arrayValue.compactMap({homeDailySalesData($0)})
                            
                            let bizStop = homeOrderResult.dictionaryObject!["bizStopYn"] as? String ?? "N"
                            
                            self.updateSalesStop(bizStop: bizStop)
                            self.updateOrderData()
                            self.updateGraphData(graphAni: true, weekSelect: self.weekSelect, daySelect: self.daySelect)
                            self.updateFavoriteData()
                            
                            self.isLoadingShow = false
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.isHidden = true
                            
                        } catch {
                            
                        }
                        
                    } else {
                        LogPrint("GET HOME DATA FAIL")
                        
                        self.isLoadingShow = false
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.isHidden = true
                    }
                } else {
                    LogPrint("NETWORK FAIL - getHomeData")
                    
                    self.isLoadingShow = false
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                }
            })
        }
    }
    
    //************************************************************************************************************************//
    
}
