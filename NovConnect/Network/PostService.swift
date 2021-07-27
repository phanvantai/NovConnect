//
//  PostService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import UIKit
import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, user: UserModel, completion: @escaping FirestoreCompletion) {
        guard let currentUid = CURRENT_USER_UID else { return }
        
        ImageUploader.upload(image: image) { result in
            switch result {
            case .success(let url):
                print("\(#function) \(url)")
                let data = ["caption": caption,
                            "timestamp": Timestamp(date: Date()),
                            "likes": 0,
                            "imageUrl": url,
                            "ownerUid": currentUid,
                            "ownerProfileImageUrl": user.profileImageUrl,
                            "ownerUsername": user.username] as [String : Any]
                
                COLLECTION_POSTS.addDocument(data: data, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func fetchPosts(completion: @escaping ([PostModel]?) -> ()) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            let posts = documents.map { PostModel(postId: $0.documentID, dictionary: $0.data())}
            completion(posts)
        }
    }
    
    static func fetchPosts(for uid: String, complection: @escaping ([PostModel]?) -> ()) {
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                complection(nil)
                return
            }
            var posts = documents.map{ PostModel(postId: $0.documentID, dictionary: $0.data()) }
            posts.sort { $0.timestamp.seconds > $1.timestamp.seconds }
            complection(posts)
        }
    }
    
    static func like(post: PostModel, completion: @escaping FirestoreCompletion) {
        guard let currentUid = CURRENT_USER_UID else { return }
        
        COLLECTION_POSTS.document(post.postId)
            .collection(POST_LIKES_COLLECTION)
            .document(currentUid)
            .setData([:]) { error in
                COLLECTION_USERS.document(currentUid)
                    .collection(USER_LIKES_COLLECTION)
                    .document(post.postId)
                    .setData([:]) { error in
                        COLLECTION_POSTS.document(post.postId)
                            .updateData(["likes": post.likes + 1], completion: completion)
                    }
            }
    }
    
    static func unlike(post: PostModel, completion: @escaping FirestoreCompletion) {
        guard let currentUid = CURRENT_USER_UID, post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId)
            .collection(POST_LIKES_COLLECTION)
            .document(currentUid).delete { error in
                COLLECTION_USERS.document(currentUid)
                    .collection(USER_LIKES_COLLECTION)
                    .document(post.postId).delete { error in
                        COLLECTION_POSTS.document(post.postId)
                            .updateData(["likes": post.likes - 1], completion: completion)
                    }
            }
    }
    
    static func checkIfUserLiked(post: PostModel, completion: @escaping (Bool) -> ()) {
        guard let currentUid = CURRENT_USER_UID else { return }
        
        COLLECTION_USERS.document(currentUid)
            .collection(USER_LIKES_COLLECTION)
            .document(post.postId)
            .getDocument { snapshot, error in
                guard let isLiked = snapshot?.exists else {
                    completion(false)
                    return
                }
                completion(isLiked)
            }
    }
}
