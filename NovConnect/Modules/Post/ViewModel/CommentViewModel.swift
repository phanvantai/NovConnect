//
//  CommentViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

struct CommentViewModel {
    private let comment: CommentModel
    
    var profileImageUrl: URL? { URL(string: comment.profileImageUrl) }
    
    var username: String { comment.username }
    
    var commentText: String { comment.comment }
    
    init(comment: CommentModel) {
        self.comment = comment
    }
    
    func commentTextLabel() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(username)  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributedString
    }
    
    func size(for width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
