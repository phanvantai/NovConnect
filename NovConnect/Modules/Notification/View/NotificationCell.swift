//
//  NotificationCell.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func notificationCell(_ cell: NotificationCell, follow user: String)
    func notificationCell(_ cell: NotificationCell, unfollow user: String)
    func notificationCell(_ cell: NotificationCell, open post: String)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: NotificationViewModel? {
        didSet { configureUI() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    // MARK: - Views
    private lazy var profileImageView = CustomProfileImageView(frame: .zero)
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    
    private lazy var followButton = CustomFollowButton(title: "Follow")
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        self.selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        profileImageView.backgroundColor = .cyan
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: profileImageView)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
        followButton.addTarget(self, action: #selector(followButtonOnClick), for: .touchUpInside)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: profileImageView)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 44, height: 44)
        postImageView.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(postImageOnClick))
        postImageView.addGestureRecognizer(imageTap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        infoLabel.attributedText = viewModel.notificationMessage
        
        postImageView.isHidden = viewModel.shouldHidePostImage
        followButton.isHidden = !viewModel.shouldHidePostImage
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
    
    // MARK: - Actions
    @objc func followButtonOnClick() {
        guard let viewModel = viewModel else { return }
        if viewModel.notification.userIsFollowing {
            delegate?.notificationCell(self, unfollow: viewModel.uid)
        } else {
            delegate?.notificationCell(self, follow: viewModel.uid)
        }
    }
    
    @objc func postImageOnClick() {
        guard let viewModel = viewModel else { return }
        delegate?.notificationCell(self, open: viewModel.postId)
    }
}
