//
//  MainTabViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureControllers()
        checkIfUserLoggedIn()
    }
    
    // MARK: - User
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
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
    
    // MARK: - Helpers
    
    func configureControllers() {
        view.backgroundColor = .clear
        
        let feedLayout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unSelectImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedViewController(collectionViewLayout: feedLayout))
        
        let search = templateNavigationController(unSelectImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchViewController())
        
        let image = templateNavigationController(unSelectImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: CreatePostViewController())
        
        let noti = templateNavigationController(unSelectImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationViewController())
        
        let profileLayout = UICollectionViewFlowLayout()
        let profile = templateNavigationController(unSelectImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: ProfileViewController(collectionViewLayout: profileLayout))
        
        viewControllers = [feed, search, image, noti, profile]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unSelectImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unSelectImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }
}
