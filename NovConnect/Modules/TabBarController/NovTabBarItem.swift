//
//  NovTabBarItem.swift
//  NovConnect
//
//  Created by Tai Phan Van on 25/07/2021.
//

import UIKit

enum NovTabBarItem: Int, CaseIterable {
    case feed = 0
    case search = 1
    case post = 2
    case notification = 3
    case profile = 4
    
    func getController(_ user: UserModel? = nil) -> UINavigationController {
        switch self {
        case .feed:
            let feedLayout = UICollectionViewFlowLayout()
            let feed = templateNavigationController(unSelectImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: FeedViewController(collectionViewLayout: feedLayout))
            return feed
        case .search:
            return templateNavigationController(unSelectImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: SearchViewController())
        case .post:
            return templateNavigationController(unSelectImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: CreatePostViewController())
        case .notification:
            return templateNavigationController(unSelectImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: NotificationViewController())
        case .profile:
            let profileVC = ProfileViewController(user: user ?? UserModel.init(dictionary: [:]))
            return templateNavigationController(unSelectImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: profileVC)
        }
    }
    
    func templateNavigationController(unSelectImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unSelectImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        
        return nav
    }
}
