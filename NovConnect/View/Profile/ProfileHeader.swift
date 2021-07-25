//
//  ProfileHeader.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit
import SDWebImage

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Views
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .black
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 14)
        return name
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(editProfileButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let gridPostsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let taggedPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileButton)
        editProfileButton.centerX(inView: self)
        editProfileButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 12, paddingRight: 12, height: 50 )
        
        let line = CustomAuthLineView()
        let bottomLine = CustomAuthLineView()
        addSubview(line)
        addSubview(bottomLine)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [gridPostsButton, taggedPostButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        line.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor)
        
        bottomLine.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func editProfileButtonOnClick() {
        viewModel?.editProfileButtonClick()
    }
    
    // MARK: - Helpers
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.fullName
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        editProfileButton.setTitle(viewModel.user.followStatus?.rawValue, for: .normal)
        editProfileButton.setTitleColor(viewModel.buttonTextColor, for: .normal)
        editProfileButton.backgroundColor = viewModel.buttonBackgroundColor
        
        followingLabel.attributedText = viewModel.following
        followersLabel.attributedText = viewModel.followers
        postsLabel.attributedText = viewModel.posts
    }
}
