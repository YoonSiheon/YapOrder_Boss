//
//  CameraPermissionViewController.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/04/26.
//

import Foundation
import UIKit

class CameraPermissionViewController: UIViewController {
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    
    @IBOutlet weak var imageTitle2: UILabel!
    @IBOutlet weak var imageDescription2: UILabel!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var labelButtonTitle: UILabel! {
        didSet {
            labelButtonTitle.text = "action_confirm".localized()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogPrint("viewDidLoad")
        
        labelDescription.text = "popup_camera_permission_description".localized()
        imageTitle.text = "popup_camera_permission_image_title".localized()
        imageDescription.text = "popup_camera_permission_image_description".localized()
        
        imageTitle2.text = "popup_camera_permission_album_title".localized()
        imageDescription2.text = "popup_camera_permission_image_description".localized()
        labelMessage.text = "popup_camera_permission_message".localized()
        
        viewButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchButton)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogPrint("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogPrint("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogPrint("viewWillDisAppear")
    }
    
    @objc func touchButton(sender: UITapGestureRecognizer) {
        LogPrint("touchButton")
        
        GlobalShareManager.shared().setLocalData(dataValue: "true", forKey: CONFIRM_CAMERA_PERMISSION)
        
        checkCameraPermission()
        checkAlbumPermission()
        
        self.dismiss(animated: false)
    }
    
}
