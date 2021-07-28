//
//  PostModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Foundation
import Firebase

struct PostModel {
    let caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let postId: String
    let timestamp: Timestamp
    
    let ownerProfileImageUrl: String
    let ownerUsername: String
    
    var isLiked: Bool = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.ownerProfileImageUrl = dictionary["ownerProfileImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
