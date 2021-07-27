//
//  CommentModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Foundation
import Firebase

struct CommentModel {
    let comment: String
    let uid: String
    let username: String
    let timestamp: Timestamp
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.comment = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
