//
//  MainTabViewController.swift
//  NovConnect
//
//  Created by Tai Phan Van on 17/07/2021.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureControllers()
    }
    
    // MARK: - Helpers
    
    func configureControllers() {
        view.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unSelectImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedViewController(collectionViewLayout: layout))
        let search = templateNavigationController(unSelectImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchViewController())
        let image = templateNavigationController(unSelectImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: CreatePostViewController())
        let noti = templateNavigationController(unSelectImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationViewController())
        let profile = templateNavigationController(unSelectImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: ProfileViewController())
        
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
