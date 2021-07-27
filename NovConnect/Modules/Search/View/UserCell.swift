//
//  UserCell.swift
//  NovConnect
//
//  Created by Tai Phan Van on 22/07/2021.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: UserCellViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Views
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .cyan
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        return label
    }()
    
    private let fulnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full Name"
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, fulnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        addSubview(stackView)
        stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        usernameLabel.text = viewModel?.username
        fulnameLabel.text = viewModel?.fullname
        profileImageView.sd_setImage(with: viewModel?.profileImageUrl, completed: nil)
    }
}
