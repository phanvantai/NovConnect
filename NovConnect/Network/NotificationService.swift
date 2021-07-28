//
//  NotificationService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Firebase

struct NotificationService {
    static func uploadNotification(to uid: String, from user: UserModel, type: NotificationType, post: PostModel? = nil) {
        guard uid != user.uid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid)
            .collection(USER_NOTIFICATIONS_COLLECTION).document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": user.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "profileImageUrl": user.profileImageUrl,
                                   "username": user.username]
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping ([NotificationModel]) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_NOTIFICATIONS.document(currentUid)
            .collection(USER_NOTIFICATIONS_COLLECTION)
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let docs = documents.map { NotificationModel(dictionary: $0.data()) }
            completion(docs)
        }
    }
}
