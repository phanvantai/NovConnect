//
//  FeedViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit
import Firebase

private let reuseIdentifier = "FeedCell"

class FeedViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var posts = [PostModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchPost()
    }
    
    // MARK: - Actions
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            let controller = LoginViewController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .flipHorizontal
            self.present(nav, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPost()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    func fetchPost() {
        DebugLog(self)
        PostService.fetchPosts() { posts in
            if let posts = posts {
                self.posts = posts
                self.checkIfUserLiked()
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func checkIfUserLiked() {
        for post in posts {
            PostService.checkIfUserLiked(post: post) { isLiked in
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId}) {
                    self.posts[index].isLiked = isLiked
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        if (indexPath.row < posts.count) {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
        var height = width + 8 + 40 + 8
        height += 40
        height += 60
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate
extension FeedViewController: FeedCellDelegate {
    func feedCellDidClickUsername(_ feedCell: FeedCell, on post: PostModel) {
        DebugLog(self)
        let uid = post.owerUid
        UserService.fetchUser(with: uid) { user in
            if let user = user {
                let profile = ProfileViewController(user: user)
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
    }
    
    func feedCellDidClickLike(_ feedCell: FeedCell, on post: PostModel) {
        feedCell.viewModel?.post.isLiked.toggle()
        if post.isLiked {
            PostService.unlike(post: post) { error in
                guard error == nil else {
                    feedCell.viewModel?.post.isLiked.toggle()
                    return
                }
                feedCell.updateUnliked()
            }
        } else {
            PostService.like(post: post) { error in
                guard error == nil else {
                    feedCell.viewModel?.post.isLiked.toggle()
                    return
                }
                feedCell.updateLiked()
            }
        }
    }
    
    func feedCellDidClickComment(_ feedCell: FeedCell, on post: PostModel) {
        DebugLog(self)
        let controller = CommentViewController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func feedCellDidClickShare(_ feedCell: FeedCell, on post: PostModel) {
        DebugLog(self)
    }
}
