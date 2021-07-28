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
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
