//
//  InputTextView.swift
//  NovConnect
//
//  Created by Tai Phan Van on 25/07/2021.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK: - Properties
    var placeholderText: String? {
        didSet {
            placeholder.text = placeholderText
        }
    }
    
    // MARK: - Views
    private let placeholder: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 6)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        //layer.cornerRadius = 5
        //layer.borderWidth = 1
        //layer.borderColor = UIColor.lightGray.cgColor
        //layer.shadowRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextViewDidChange() {
        placeholder.isHidden = !text.isEmpty
    }
    
    func showPlaceholder() {
        placeholder.isHidden = false
    }
}
