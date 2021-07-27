//
//  CommentCell.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: CommentViewModel? {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Views
    private let profileImageView = CustomProfileImageView(frame: .zero)
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingLeft: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        profileImageView.sd_setImage(with: viewModel?.profileImageUrl)
        
        commentLabel.attributedText = viewModel?.commentTextLabel()
    }
}
