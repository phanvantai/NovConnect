//
//  MainTabViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    private var user: UserModel? {
        didSet {
            guard let user = user else { return }
            configureControllers(withUser: user)
        }
    }
    
    private var lastSelectedIndex = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        fetchUser()
    }
    
    // MARK: - User
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .flipHorizontal
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCurrentUser() -> UserModel? { user }
    
    // MARK: - Helpers
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(with: uid) { user in
            self.user = user
        }
    }
    
    func configureControllers(withUser user: UserModel) {
        view.backgroundColor = .white
        self.delegate = self
        
        let controllers = NovTabBarItem.allCases/*.sorted(by: {$0.rawValue < $1.rawValue})*/
            .map{ $0.getController(user)}
        viewControllers = controllers
        
        tabBar.tintColor = .black
    }
    
    func presentPost() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        
        didFinishPickingMedia(picker)
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { item, cancel in
            if cancel {
                self.selectedIndex = self.lastSelectedIndex
                picker.dismiss(animated: true, completion: nil)
            } else {
                picker.dismiss(animated: true) {
                    guard let selectedPhoto = item.singlePhoto?.image else {
                        return
                    }
                    let post = UploadPostViewController()
                    post.user = self.user
                    post.postImage = selectedPhoto
                    post.delegate = self
                    let nav = UINavigationController(rootViewController: post)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: false, completion: nil)
                }
            }
        }
    }
}

// MARK: - AuthenticationDelgate
extension MainTabController: AuthenticationDelgate {
    func authenticationDidFinish() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == NovTabBarItem.post.rawValue {
            self.presentPost()
        } else {
            lastSelectedIndex = index ?? lastSelectedIndex
        }
        return true
    }
}

// MARK: - UploadPostViewControllerDelegate
extension MainTabController: UploadPostViewControllerDelegate {
    func uploadPostDidCancel(_ viewController: UIViewController) {
        selectedIndex = lastSelectedIndex
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func uploadPostDidComplete(_ viewController: UIViewController) {
        selectedIndex = 0
        viewController.dismiss(animated: true, completion: nil)
        
        guard let nav = viewControllers?.first as? UINavigationController,
              let feed = nav.viewControllers.first as? FeedViewController else { return }
        feed.handleRefresh()
    }
}
