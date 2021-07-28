//
//  NotificationModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like:
            return " liked your post."
        case .follow:
            return " started following you."
        case .comment:
            return " commented on your post."
        }
    }
}

struct NotificationModel {
    
    let uid: String
    let postId: String
    let postImageUrl: String?
    let profileImageUrl: String
    let username: String
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    
    var userIsFollowing = false
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
