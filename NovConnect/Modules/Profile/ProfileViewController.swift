//
//  ProfileViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

private let profileCellIdentifier = "ProfileCell"
private let profileHeaderIdentifier = "ProfileHeader"

class ProfileViewController: UICollectionViewController {
    
    // MARK: - Properties
    private var user: UserModel
    private var posts = [PostModel]() {
        didSet {
            user.posts = posts.count
        }
    }
    
    init(user: UserModel) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = user.username
        configureCollectionView()
        updateProfile()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfile()
    }
    
    // MARK: - SetupUI
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: profileCellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileHeaderIdentifier )
    }
    
    // MARK: - Helpers
    
    func updateProfile() {
        fetchUser()
        fetchFollowers()
        fetchFollowing()
    }
    
    func fetchUser() {
        if user.isCurrentUser {
            user.followStatus = .current
        } else {
            UserService.checkIfUserIsFollowing(user: user.uid) { result in
                self.user.followStatus = result ? .following : .notFollow
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchFollowers() {
        UserService.fetchFollowers(of: user) { followers in
            self.user.followers = followers
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchFollowing() {
        UserService.fetchFollowing(of: user) { following in
            self.user.following = following
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(for: user.uid) { posts in
            if let posts = posts {
                self.posts = posts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DebugLog("didSelect")
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellIdentifier, for: indexPath) as! ProfileCell
        if indexPath.row < posts.count {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderIdentifier, for: indexPath) as! ProfileHeader
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.viewModel?.delegate = self
        
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: ProfileHeaderViewModelDelegate {
    func profileHeaderDidFollow(_ userModel: UserModel) {
        guard let tab = tabBarController as? MainTabController,
              let user = tab.getCurrentUser() else { return }
        NotificationService.uploadNotification(to: userModel.uid, from: user, type: .follow)
    }
    
    func profileHeaderDidClickEditProfile(_ viewModel: ProfileHeaderViewModel) {
        print(#function)
        // TODO: - Edit profile
    }
    
    func profileHeaderDidUpdate(_ userModel: UserModel) {
        DebugLog(self)
        self.updateProfile()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }
}
