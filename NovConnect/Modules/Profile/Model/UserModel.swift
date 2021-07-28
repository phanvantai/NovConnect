//
//  UserModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Foundation
import Firebase

enum FollowStatus: String {
    case current = "Edit Profile"
    case following = "Following"
    case notFollow = "Follow"
}

struct UserModel {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    var followStatus: FollowStatus?
    
    var following = 0
    var followers = 0
    var posts = 0
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        email = dictionary["email"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
}
