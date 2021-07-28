//
//  ProfileHeaderViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import UIKit
import Firebase

protocol ProfileHeaderViewModelDelegate: AnyObject {
    func profileHeaderDidClickEditProfile(_ viewModel: ProfileHeaderViewModel)
    func profileHeaderDidUpdate(_ userModel: UserModel)
    func profileHeaderDidFollow(_ userModel: UserModel)
}

struct ProfileHeaderViewModel {
    var user: UserModel
    
    weak var delegate: ProfileHeaderViewModelDelegate?
    
    var fullName: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl) 
    }
    
    var currentUid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var followers: NSAttributedString {
        return attributedStatText(value: user.followers, label: "Followers")
    }
    
    var following: NSAttributedString {
        return attributedStatText(value: user.following, label: "Following")
    }
    
    var posts: NSAttributedString {
        return attributedStatText(value: user.posts, label: "Posts")
    }
    
    var buttonBackgroundColor: UIColor {
        switch user.followStatus {
        case .current:
            return .white
        default:
            return .systemBlue
        }
    }
    
    var buttonTextColor: UIColor {
        switch user.followStatus {
        case .current:
            return .black
        default:
            return .white
        }
    }
    
    init(user: UserModel) {
        self.user = user
    }
    
    func editProfileButtonClick() {
        switch user.followStatus {
        case .current:
            delegate?.profileHeaderDidClickEditProfile(self)
        case .following:
            // TODO: - unfollow user
            UserService.unfollow(user: user.uid) { success in
                self.delegate?.profileHeaderDidUpdate(user)
                
                PostService.updateUserFeed(user: user.uid, isFollow: false)
            }
        case .notFollow:
            // TODO: - follow user
            UserService.follow(user: user.uid) { success in
                delegate?.profileHeaderDidUpdate(user)
                
                delegate?.profileHeaderDidFollow(user)
                
                PostService.updateUserFeed(user: user.uid, isFollow: true)
            }
        case .none:
            print("\(#function) do nothing")
        }
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray ]))
        
        return attributedText
    }
}
