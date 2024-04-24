//
//  CommonData.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/09.
//

import Foundation
import UIKit

enum PopupPosition: String {
    case top = "Top"
    case bottom = "Bottom"
    case left = "Left"
    case right = "Rigth"
    case center = "Center"
    case none = ""
}

enum PopupType: String {
    case fadeInOut = "Fade In Out"
    case move = "Move"
    case none = ""
    case default1 = "default1"
}


//let TEXTCOLOR: UIColor = COMMON_BLACK
//let TEXTCOLOR_BLUE: UIColor = COMMON_BLUE
//let TEXTCOLOR_GRAY: UIColor = COMMON_GRAY

let COMMON_WHITE: UIColor   = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) //common white
let COMMON_BLACK: UIColor   = UIColor.init(red:  25/255, green:  25/255, blue:  25/255, alpha: 1.0) //common black
let COMMON_ORANGE: UIColor  = UIColor.init(red: 255/255, green:  93/255, blue:  28/255, alpha: 1.0) //common orange
let COMMON_GRAY1: UIColor   = UIColor.init(red: 118/255, green: 118/255, blue: 118/255, alpha: 1.0) //common gray1
let COMMON_GRAY2: UIColor   = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0) //common gray2
let COMMON_GRAY3: UIColor   = UIColor.init(red: 229/255, green: 233/255, blue: 243/255, alpha: 1.0) //common gray3 popupbutton border
let COMMON_GRAY4: UIColor   = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0) //common gray3 graphbar nonselect

let DARK_COLOR: UIColor = UIColor.init(red: 19/255, green: 19/255, blue: 43/255, alpha: 1.0)
let TAB_BAR_BORDER_COLOR: UIColor = UIColor.init(red: 207/255, green: 207/255, blue: 207/255, alpha: 1.0)
let TAB_BAR_TITLE_COLOR_DEFAULT: UIColor = UIColor.init(red: 122/255, green: 122/255, blue: 129/255, alpha: 1.0)
let TAB_BAR_TITLE_COLOR_SELECTED: UIColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)

let MAIN_TBBAR_HEIGHT: CGFloat = 64
let MAIN_TABBAR_INFO: [[CGFloat]] = [ [84, -5],
                                      [64, -2] ]

//let POPUP_NOTITLE_POPUP_HEIGHT: CGFloat = 208       // notitle(description 2line)
//let POPUP_TITLE_POPUP_HEIGHT_2LINE: CGFloat = 238   // title  (description 2line)
//let POPUP_TITLE_POPUP_HEIGHT_3LINE: CGFloat = 268   // title  (description 3line)
//let POPUP_NOTITLE_POPUP_DESCRIPTION_HEIGHT: CGFloat = 40 // notitle
//let POPUP_TITLE_POPUP_DESCRIPTION_HEIGHT: CGFloat = 85   // title

let ORDER_VIEW_HEIGHT_ORDER: CGFloat = 246
let ORDER_VIEW_HEIGHT_RESERVATION: CGFloat = 311
let ORDER_VIEW_HEIGHT_ORDER_CANCEL: CGFloat = 186
let ORDER_VIEW_HEIGHT_RESERVATION_CANCEL: CGFloat = 246

let ORDER_DETAIL_PRODUCT_CELL_HEIGHT: CGFloat = 54
let ORDER_DETAIL_PRODUCT_CELL_HEIGHT_OPTION: CGFloat = 23

let POPUP_VARIABLE_CELL_HEIGHT: CGFloat = 63
let POPUP_VARIABLE_TITLE_HEIGHT: CGFloat = 98
let POPUP_VARIABLE_CANCEL_HEIGHT: CGFloat = 350
let POPUP_VARIABLE_ESTIMATETIME_HEIGHT: CGFloat = 476

let POPUP_TITLE_POPUP_HEIGHT_2LINE: CGFloat = 200   // title  (description 2line)
let POPUP_TITLE_POPUP_HEIGHT_3LINE: CGFloat = 225   // title  (description 3line) device width > 450
let POPUP_TITLE_POPUP_HEIGHT_3LINE_WIDTH2: CGFloat = 235   // title  (description 3line) device width > 390
let POPUP_TITLE_POPUP_HEIGHT_3LINE_WIDTH3: CGFloat = 245   // title  (description 3line) device width < 390

let FAVORITE_HEIGHT: [CGFloat] = [349, 447, 74]
