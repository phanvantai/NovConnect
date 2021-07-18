//
//  CustomAuthLabel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class CustomAuthLabel: UILabel {
    
    init(label: String) {
        super.init(frame: .zero)
        
        text = label
        textColor = .lightGray
        font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
