//
//  HomeWeeklySales.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/17.
//

import Foundation
import UIKit
import ChartProgressBar

class HomeWeeklySalesCell: UITableViewCell, ChartProgressBarDelegate {
    
    var viewController: UIViewController?
    
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = "home_weeklysales_title".localized()
        }
    }
    
    @IBOutlet weak var barChartView: ChartProgressBar!
    var strWeekly: [String]!
    var iValue: [Double]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        initCharts()
    }
    
    func initCharts() {
        
        var data: [BarData] = []
        
        data.append(BarData.init(barTitle: "Jan", barValue: 1.4, pinText: "1.4 €"))
        data.append(BarData.init(barTitle: "Feb", barValue: 10, pinText: "10 €"))
        data.append(BarData.init(barTitle: "Mar", barValue: 3.1, pinText: "3.1 €"))
        data.append(BarData.init(barTitle: "Apr", barValue: 4.8, pinText: "4.8 €"))
        data.append(BarData.init(barTitle: "May", barValue: 6.6, pinText: "6.6 €"))
        data.append(BarData.init(barTitle: "Jun", barValue: 7.4, pinText: "7.4 €"))
        data.append(BarData.init(barTitle: "Jul", barValue: 5.5, pinText: "5.5 €"))

        barChartView.data = data
        barChartView.barsCanBeClick = true
        barChartView.maxValue = 10.0
//        barChartView.emptyColor = UIColor.clear
//        barChartView.barWidth = 7
//        barChartView.progressColor = UIColor.init(hexString: "99ffffff")
//        barChartView.progressClickColor = UIColor.init(hexString: "F2912C")
//        barChartView.pinBackgroundColor = UIColor.init(hexString: "E2335E")
//        barChartView.pinTxtColor = UIColor.init(hexString: "ffffff")
//        barChartView.barTitleColor = UIColor.init(hexString: "B6BDD5")
//        barChartView.barTitleSelectedColor = UIColor.init(hexString: "FFFFFF")
//        barChartView.pinMarginBottom = 15
//        barChartView.pinWidth = 70
//        barChartView.pinHeight = 29
//        barChartView.pinTxtSize = 17
        barChartView.delegate = self
        barChartView.build()
        barChartView.disableBar(at: 3)
        let when = DispatchTime.now() + 6 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.barChartView.enableBar(at: 3)
        }
        
        //        barChartView.delegate = self
        //
        //        barChartView.noDataText = "데이터가 없습니다."
        //        barChartView.noDataFont = .systemFont(ofSize: 20)
        //        barChartView.noDataTextColor = .white
        //
        //        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //
        //        LogPrint("\(nowWeekday().iDay), \(nowWeekday().strDay)")
        //
        //        strWeekly = ["일", "월", "화", "수", "목", "금", "토"]
        //        iValue = [10000, 40000, 25000, 60000, 15000, 30000, 15000]
        //
        //        setData(dataPoints: strWeekly, values: iValue)
        //        setChart()
        
    }
    
    //    func setData(dataPoints: [String], values: [Double]) {
    //        // 데이터 생성
    //        var dataEntries: [BarChartDataEntry] = []
    //        for i in 0..<dataPoints.count {
    //            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
    //            dataEntries.append(dataEntry)
    //        }
    //
    //        //let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
    //        let chartDataSet = BarChartDataSet(entries: dataEntries)
    //
    //        // 차트 컬러
    ////        chartDataSet.setColor(.gray)  //전체 컬러
    //        var iColor: [NSUIColor] = [.gray, .gray, .gray, .gray, .gray, .gray, .gray]  //전체 컬러
    //        iColor[nowWeekday().iDay - 1] = .blue  //개별 컬러
    //        chartDataSet.setColors(iColor, alpha: 1)
    //
    //        // 선택 안되게
    //        chartDataSet.highlightEnabled = false
    //
    //        // 데이터 삽입
    //        let chartData = BarChartData(dataSet: chartDataSet)
    //        chartData.setDrawValues(true)
    //        chartData.setValueTextColor(.blue)
    //
    //        barChartView.data = chartData
    //    }
    //
    //    func setChart() {
    //
    //        // 기본 애니메이션
    ////        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    //        barChartView.animate(yAxisDuration: 1.5 , easingOption: .easeOutBounce)
    //        // 맥시멈
    //        barChartView.leftAxis.axisMaximum = 80000
    //        // 미니멈
    //        barChartView.leftAxis.axisMinimum = 0
    //
    //        // Hightlight
    //        barChartView.highlightPerTapEnabled = true
    //        barChartView.highlightFullBarEnabled = true
    //        barChartView.highlightPerDragEnabled = false
    //
    //        // disable zoom function
    //        barChartView.pinchZoomEnabled = false
    //        barChartView.setScaleEnabled(false)
    //        barChartView.doubleTapToZoomEnabled = false
    //
    //        // Bar, Grid Line, Background
    //        barChartView.drawBarShadowEnabled = false
    //        barChartView.drawGridBackgroundEnabled = false
    //        barChartView.drawBordersEnabled = false
    ////        barChartView.borderColor = .gray
    //
    //        // Legend
    //        barChartView.legend.enabled = false
    //
    //        // Setup X axis
    //        let xAxis = barChartView.xAxis
    //        xAxis.labelPosition = .bottom //항목 레이블 표시위치
    //        xAxis.drawAxisLineEnabled = true //아래 틀 라인
    //        xAxis.drawGridLinesEnabled = false //x 라인
    //        xAxis.granularityEnabled = false
    //        xAxis.labelRotationAngle = 0 //항목 레이블 각도
    //        xAxis.setLabelCount(strWeekly.count, force: false) //항목 레이블 최대 개수로 설정
    //        xAxis.valueFormatter = IndexAxisValueFormatter(values: strWeekly) //항목 레이블 명칭
    //        xAxis.axisMaximum = Double(strWeekly.count) //항목 레이블 개수
    //        xAxis.axisLineColor = .gray //아래 틀 라인 컬러
    //        xAxis.labelTextColor = .gray //항목 레이블 컬러
    //
    //        // Setup left axis
    //        let leftAxis = barChartView.leftAxis
    //        leftAxis.drawTopYLabelEntryEnabled = true //제일 위 라인의 레이블
    //        leftAxis.drawAxisLineEnabled = false //왼쪽 틀 라인
    //        leftAxis.drawGridLinesEnabled = true //단위 라인
    //        leftAxis.granularityEnabled = false
    //        leftAxis.axisLineColor = .gray //왼쪽 틀 라인 컬러
    //        leftAxis.labelTextColor = .gray //단위 레이블 컬러
    //
    //        leftAxis.setLabelCount(5, force: true) // 단위나오는 개수
    //
    //        // Remove right axis
    //        let rightAxis = barChartView.rightAxis
    //        rightAxis.enabled = false
    //
    //    }
    
    @IBAction func actionDetail(_ sender: Any) {
        LogPrint("actionDetail")
    }
    
    func ChartProgressBar(_ chartProgressBar: ChartProgressBar, didSelectRowAt rowIndex: Int) {
        LogPrint(rowIndex)
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
