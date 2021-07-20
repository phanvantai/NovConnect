//
//  LoginViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

struct LoginViewModel: AuthenticationProtocol {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }

    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor(red: 0.00, green: 0.60, blue: 0.99, alpha: 1.00) : UIColor(red: 0.35, green: 0.80, blue: 0.99, alpha: 1.00)
    }
}
