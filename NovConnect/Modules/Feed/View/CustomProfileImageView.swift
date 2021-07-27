//
//  CustomProfileImageView.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

class CustomProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        contentMode = .scaleAspectFill
        clipsToBounds = true
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
