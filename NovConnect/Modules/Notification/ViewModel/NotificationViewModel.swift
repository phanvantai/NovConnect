//
//  NotificationViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit

struct NotificationViewModel {
    
    var notification: NotificationModel
    
    init(notification: NotificationModel) {
        self.notification = notification
    }
    
    var timestampLabel: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute,.hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    var followButtonText: String {
        return notification.userIsFollowing ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowing ? .white : UIColor(red: 0.00, green: 0.59, blue: 1.00, alpha: 1.00)
    }
    
    var followButtonHighlightBackground: UIColor {
        return notification.userIsFollowing ? .white : UIColor(red: 0.30, green: 0.71, blue: 1.00, alpha: 1.00)
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowing ? .black : .white
    }
    
    var postId: String { notification.postId }
    var uid: String { notification.uid }
    
    var postImageUrl: URL? { URL(string: notification.postImageUrl ?? "") }
    
    var profileImageUrl: URL? { URL(string: notification.profileImageUrl) }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attribute = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attribute.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        if let timestamp = timestampLabel {
            attribute.append(NSAttributedString(string: " \(timestamp)" , attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        }
        return attribute
    }
    
    var shouldHidePostImage: Bool { self.notification.type == .follow }
}
