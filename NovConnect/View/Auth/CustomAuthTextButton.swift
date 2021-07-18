//
//  CustomAuthTextButton.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class CustomAuthTextButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor(red: 0.00, green: 0.60, blue: 0.99, alpha: 1.00), for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
