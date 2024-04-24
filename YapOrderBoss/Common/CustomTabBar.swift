//
//  CustomTabBar.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/01/10.
//

import UIKit

class CustomTabBar: UITabBar {
    
    @IBInspectable var height: CGFloat = MAIN_TBBAR_HEIGHT
    
    private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    // 아이폰 x 이상부터 .. 밑부분 값 구함
    override var safeAreaInsets: UIEdgeInsets {
        let insets = super.safeAreaInsets
        
        if insets.bottom < bounds.height {
            cachedSafeAreaInsets = insets
        }
//        LogPrint("cachedSafeAreaInsets:\(cachedSafeAreaInsets)")
        
        return cachedSafeAreaInsets
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height + cachedSafeAreaInsets.bottom
        }
//        LogPrint("sizeThatFits:\(sizeThatFits)")
        return sizeThatFits
    }
}
class MainTabBarItem: UITabBarItem {
}
class TopTabBarItem : UITabBarItem {
}

