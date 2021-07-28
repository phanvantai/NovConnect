//
//  FeedCell.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func feedCellDidClickUsername(_ feedCell: FeedCell, on post: PostModel)
    func feedCellDidClickLike(_ feedCell: FeedCell, on post: PostModel)
    func feedCellDidClickComment(_ feedCell: FeedCell, on post: PostModel)
    func feedCellDidClickShare(_ feedCell: FeedCell, on post: PostModel)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            configureUI()
        }
    }
    
    weak var delegate: FeedCellDelegate?
    
    // MARK: - Views
    private lazy var profileImageView = CustomProfileImageView(frame: .zero)
    
    private lazy var userNameButton = CustomUsernameButton(frame: .zero)
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(likeButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(commentButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 20
        
        addSubview(userNameButton)
        userNameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureButtons()
        
        addSubview(likeLabel)
        likeLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        configureActions()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureActions() {
        userNameButton.addTarget(self, action: #selector(profileOnClick), for: .touchUpInside)
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(profileOnClick))
        profileImageView.addGestureRecognizer(ges)
    }
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl)
        likeLabel.text = viewModel.likes
        profileImageView.sd_setImage(with: viewModel.ownerProfileImageUrl)
        userNameButton.setTitle(viewModel.ownerUsername, for: .normal)
        postTimeLabel.text = "\(viewModel.timestampLabel ?? "2 hours") ago"
        
        viewModel.isLiked ? setLiked() : setNotLiked()
    }
    func configureButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 40)
    }
    
    func updateLiked() {
        viewModel?.post.likes += 1
        setLiked()
    }
    
    func updateUnliked() {
        viewModel?.post.likes -= 1
        setNotLiked()
    }
    
    func setLiked() {
        likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
        likeButton.tintColor = .red
    }
    
    func setNotLiked() {
        likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        likeButton.tintColor = .black
    }
    
    // MARK: - Actions
    @objc func profileOnClick() {
        DebugLog(self)
        guard let viewModel = viewModel else { return }
        delegate?.feedCellDidClickUsername(self, on: viewModel.post)
    }
    
    @objc func commentButtonOnClick() {
        DebugLog(self)
        guard let viewModel = viewModel else { return }
        delegate?.feedCellDidClickComment(self, on: viewModel.post)
    }
    
    @objc func likeButtonOnClick() {
        DebugLog(self)
        guard let viewModel = viewModel else { return }
        delegate?.feedCellDidClickLike(self, on: viewModel.post)
    }
    
    @objc func shareButtonOnClick() {
        DebugLog(self)
        guard let viewModel = viewModel else { return }
        delegate?.feedCellDidClickShare(self, on: viewModel.post)
    }
}
