//
//  Constants.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Firebase

public func DebugLog<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    print("[Debug] \((file as NSString).lastPathComponent) \(function) \(line): \(message)")
#endif
}

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")

let COMMENTS_COLLECTION = "comments"
let FOLLOWING_COLLECTION = "user-following"
let FOLLOWERS_COLLECTION = "user-followers"
let POST_LIKES_COLLECTION = "post-likes"
let USER_LIKES_COLLECTION = "user-likes"
let USER_NOTIFICATIONS_COLLECTION = "user-notifications"
let USER_FEED = "user-feed"

let IMAGE_STORAGE = "profile_images"
