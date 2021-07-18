//
//  CustomAuthActionButton.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class CustomAuthActionButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        backgroundColor = UIColor(red: 0.35, green: 0.80, blue: 0.99, alpha: 1.00)
        layer.cornerRadius = 5
        setHeight(44)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
