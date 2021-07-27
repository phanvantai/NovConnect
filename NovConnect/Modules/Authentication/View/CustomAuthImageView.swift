//
//  CustomAuthImageView.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit

class CustomAuthImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        image = UIImage(named: "instagram_new")
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
