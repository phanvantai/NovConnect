//
//  CustomUsernameButton.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

class CustomUsernameButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.black, for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
