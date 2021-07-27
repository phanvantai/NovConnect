//
//  CommentViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

private let reuserIdentifier = "CommentCell"

class CommentViewController: UICollectionViewController {
    
    // MARK: - Properties
    private let post: PostModel
    private var comments: [CommentModel] = []
    
    // MARK: - Views
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let input = CommentInputAccessoryView(frame: frame)
        input.delegate = self
        return input
    }()
    
    // MARK: - Lifecycle
    
    init(post: PostModel) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        configureCollectionView()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    func fetchComments() {
        CommentService.fetchComment(for: post.postId) { comments in
            self.comments = comments
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CommentViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! CommentCell
        if indexPath.row < comments.count {
            cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CommentViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(with: uid) { user in
            if let user = user {
                let profile = ProfileViewController(user: user)
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(for: view.frame.width).height + 32
        return CGSize(width: self.view.frame.width, height: height)
    }
}

// MARK: - CommentInputDelegate
extension CommentViewController: CommentInputDelegate {
    func commentInput(_ input: CommentInputAccessoryView, didPostComment comment: String) {
        DebugLog(self)
        
        showLoading(true)
        guard let tab = tabBarController as? MainTabController,
              let user = tab.getCurrentUser() else { return }
        
        CommentService.uploadComment(comment: comment, postId: post.postId, user: user) { error in
            self.showLoading(false)
            input.clearCommentTextView()
        }
    }
}
