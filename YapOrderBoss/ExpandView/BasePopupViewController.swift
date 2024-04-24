//
//  BasePopupViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/16.
//

import Foundation
import UIKit
import SnapKit

class BasePopupViewController: UIViewController {
    
    // popup animation type
    private var type: PopupType = .none
    
    // popup push start position
    private var position: PopupPosition = .none
    
    // popup dim 투명도
    private final let DIM_ALPHA: CGFloat = 0.3
    public let ANIMATION_DURATION: TimeInterval = 0.3
    public let ANIMATION_DELAYDURATION: TimeInterval = 6.0
    
    var baseViewBack: UIView!
    var baseViewPopup: UIView!
    
    var basePopupType: String!
    
    var tabbarHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
        
        if basePopupType == "noti" {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + ANIMATION_DELAYDURATION) {
                self.hideAnim(type: self.type, position: self.position) { }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
}


extension BasePopupViewController {
    func showAnim(vc: UIViewController? = UIApplication.shared.windows.first?.visibleViewController, bgColor: CGFloat = 0.02, tapbarHidden: Bool = false, hidePopupTabbarHidden: Bool = false, type: PopupType = .fadeInOut, position: PopupPosition = .none, parentAddView: UIView?, _ completion: @escaping ()->()) {
        guard let currentVC = vc else {
            completion()
            return
        }
        
        var pView = parentAddView
        
        if pView == nil {
            pView = vc?.view
        }
        
        guard let parentView = pView else {
            completion()
            return
        }
        
        self.tabbarHidden = hidePopupTabbarHidden
        self.type = type
        self.position = position
        
        currentVC.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(self.view)
        self.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        switch type {
        case .fadeInOut:
            self.baseViewBack.alpha = 0.0
            self.baseViewPopup.alpha = 0.0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: ANIMATION_DURATION/2) { [weak self] in
                if let _self = self {
                    _self.baseViewBack.alpha = bgColor
                }
            } completion: { (complete) in
                UIView.animate(withDuration: self.ANIMATION_DURATION/2) { [weak self] in
                    if let _self = self {
                        _self.baseViewPopup.alpha = 1.0
                    }
                } completion: { (complete) in
                    completion()
                }
            }
            
        case .move:
            self.baseViewBack.alpha = 0.0
            let originalTransform = self.baseViewPopup.transform
            
            var moveX: CGFloat = 0.0
            var moveY: CGFloat = 0.0
            
            switch position {
            case .top:
                moveX = 0.0
                moveY = -(self.baseViewPopup.frame.maxY)
            case .bottom:
                moveX = 0.0
                moveY = UIScreen.main.bounds.size.height - self.baseViewPopup.frame.minY
            case .left:
                moveX = -(self.baseViewPopup.frame.maxX)
                moveY = 0.0
            case .right:
                moveX = UIScreen.main.bounds.size.width - self.baseViewPopup.frame.minX
                moveY = 0.0
            case .center:
                moveX = 0.0
                moveY = 0.0
            default:
                break
            }
            
            let hideTransform = originalTransform.translatedBy(x: moveX, y: moveY)
            self.baseViewPopup.transform = hideTransform
            self.baseViewPopup.alpha = 0.0
            
            UIView.animate(withDuration: ANIMATION_DURATION) { [weak self] in
                if let _self = self {
                    _self.baseViewPopup.transform = originalTransform
                    _self.baseViewPopup.alpha = 1.0
                    _self.baseViewBack.alpha = bgColor
                }
            } completion: { (complete) in
                completion()
            }
            
        case .default1:
            LogPrint("type: default1")
            
        default:
            completion()
        }
        
        self.tabBarController?.tabBar.isHidden = tapbarHidden
    }
    
    func hideAnim(type: PopupType = .none, position: PopupPosition = .none, _ completion: @escaping ()->()) {
        DispatchQueue.main.async {
            
            switch self.type {
            case .fadeInOut:
                UIView.animate(withDuration: self.ANIMATION_DURATION/2, animations: { [weak self] in
                    if let _self = self {
                        _self.baseViewPopup.alpha = 0.0
                    }
                }) { (complete) in
                    UIView.animate(withDuration: self.ANIMATION_DURATION/2, animations: { [weak self] in
                        self?.baseViewBack.alpha = 0.0
                    }) { [weak self] complete in
                        if let _self = self {
                            _self.view.removeFromSuperview()
                            _self.removeFromParent()
                        }
                    }
                }
                break
            case .move:
                let originalTransform = self.baseViewPopup.transform
                
                var moveX: CGFloat = 0.0
                var moveY: CGFloat = 0.0
                
                switch position {
                case .top:
                    moveX = 0.0
                    moveY = -(self.baseViewPopup.frame.maxY)
                case .bottom:
                    moveX = 0.0
                    moveY = UIScreen.main.bounds.size.height - self.baseViewPopup.frame.minY
                case .left:
                    moveX = -(self.baseViewPopup.frame.maxX)
                    moveY = 0.0
                case .right:
                    moveX = UIScreen.main.bounds.size.width - self.baseViewPopup.frame.minX
                    moveY = 0.0
                case .center:
                    moveX = 0.0
                    moveY = 0.0
                default:
                    break
                }
                
                let hideTransform = originalTransform.translatedBy(x: moveX, y: moveY)
                                
                UIView.animate(withDuration: self.ANIMATION_DURATION, animations: { [weak self] in
                    if let _self = self {
                        _self.baseViewBack.alpha = 0.0
                        _self.baseViewPopup.alpha = 0.0
                        _self.baseViewPopup.transform = hideTransform
                    }
                }) { [weak self] complete in
                    if let _self = self {
                        _self.view.removeFromSuperview()
                        _self.removeFromParent()
                        completion()
                    }
                }
                break
                
            case .default1:
                LogPrint("type: default1")
                
            default:
                completion()
            }
            
            self.tabBarController?.tabBar.isHidden = self.tabbarHidden
        }
    }
}


