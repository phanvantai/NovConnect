//
//  CommentInputAccessoryView.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

protocol CommentInputDelegate: AnyObject {
    func commentInput(_ input: CommentInputAccessoryView, didPostComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    weak var delegate: CommentInputDelegate?
    
    // MARK: - Views
    private let commentInput: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Add a comment"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentInput)
        commentInput.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let line = UIView()
        line.backgroundColor = .lightGray
        addSubview(line)
        line.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        postButton.addTarget(self, action: #selector(postButtonOnClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func clearCommentTextView() {
        commentInput.text = ""
        commentInput.showPlaceholder()
    }
    
    // MARK: - Actions
    @objc func postButtonOnClick() {
        DebugLog(self)
        delegate?.commentInput(self, didPostComment: commentInput.text)
    }
}
