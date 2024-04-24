//
//  LoadingCell.swift
//  YapOrderBoss
//
//  Created by Yap MacBook on 2023/02/23.
//

import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
    
}
