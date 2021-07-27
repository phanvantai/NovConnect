//
//  CustomAuthTextField.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class CustomAuthTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let left = UIView()
        left.setDimensions(height: 44, width: 8)
        leftView = left
        leftViewMode = .always
        
        textColor = .black
        font = UIFont.systemFont(ofSize: 14)
        backgroundColor = UIColor(white: 0, alpha: 0.02)
        borderStyle = .roundedRect
        keyboardAppearance = .light
        self.placeholder = placeholder
        setHeight(44)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
