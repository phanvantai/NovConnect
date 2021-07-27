//
//  UIViewController+Extensions.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let HUD = JGProgressHUD(style: .dark)
    
    func showLoading(_ show: Bool) {
        view.endEditing(true)
        
        show ? UIViewController.HUD.show(in: view) : UIViewController.HUD.dismiss()
    }
}
