//
//  UploadPostViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 25/07/2021.
//

import UIKit

protocol UploadPostViewControllerDelegate: AnyObject {
    func uploadPostDidComplete(_ viewController: UIViewController)
    func uploadPostDidCancel(_ viewController: UIViewController)
}

class UploadPostViewController: UIViewController {
    // MARK: - Properties
    var user: UserModel?
    var postImage: UIImage? {
        didSet {
            postImageView.image = postImage
        }
    }
    
    weak var delegate: UploadPostViewControllerDelegate?
    
    // MARK: - Views
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "upload_image_icon")
        return iv
    }()
    
    private let captionTextView: UITextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption.."
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    private let charsCaptionCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1/300"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        self.view.backgroundColor = .white
        navigationItem.title = "New post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelUploadPost))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(sharePostOnClick))
        
        view.addSubview(postImageView)
        postImageView.setDimensions(height: 180, width: 180)
        postImageView.centerX(inView: view)
        postImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        postImageView.layer.cornerRadius = 10
        
        let topLine = UIView()
        topLine.backgroundColor = .lightGray
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        view.addSubview(topLine)
        view.addSubview(bottomLine)
        topLine.anchor(top: postImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, height: 0.4)
        
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: topLine.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12, height: 80)
        bottomLine.anchor(top: captionTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingBottom: 8, height: 0.4)
    }
    
    @objc func sharePostOnClick() {
        DebugLog(self)
        
        guard let image = postImage,
              let caption = captionTextView.text,
              let user = user else { return }
        showLoading(true)
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoading(false)
            if let error = error {
                print("\(#function) \(error.localizedDescription)")
                return
            }
            
            self.delegate?.uploadPostDidComplete(self)
        }
    }
    
    @objc func cancelUploadPost() {
        delegate?.uploadPostDidCancel(self)
    }
}
