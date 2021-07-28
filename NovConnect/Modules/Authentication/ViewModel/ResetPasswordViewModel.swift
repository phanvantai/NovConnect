//
//  ResetPasswordViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 28/07/2021.
//

import UIKit

struct ResetPasswordViewModel: AuthenticationProtocol {
    
    var email: String?
    
    var formIsValid: Bool { email?.isEmpty == false }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor(red: 0.00, green: 0.60, blue: 0.99, alpha: 1.00) : UIColor(red: 0.35, green: 0.80, blue: 0.99, alpha: 1.00)
    }
    
    
}
