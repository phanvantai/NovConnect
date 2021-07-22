//
//  UserModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Foundation

struct UserModel {
    let email: String
    let fullname: String
    let profileImageUrl: String
    let username: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        email = dictionary["email"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
}
