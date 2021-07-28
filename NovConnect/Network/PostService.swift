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
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
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
                
                let docref = COLLECTION_POSTS.addDocument(data: data, completion: completion)
                updateUserFeed(postId: docref.documentID)
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
    
    static func fetchPosts(for uid: String, completion: @escaping ([PostModel]?) -> ()) {
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            var posts = documents.map{ PostModel(postId: $0.documentID, dictionary: $0.data()) }
            posts.sort { $0.timestamp.seconds > $1.timestamp.seconds }
            completion(posts)
        }
    }
    
    static func fetchPost(with id: String, completion: @escaping (PostModel) -> ()) {
        COLLECTION_POSTS.document(id).getDocument { snapshot, error in
            guard let snapshot = snapshot, let data = snapshot.data() else { return }
            let post = PostModel(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func like(post: PostModel, completion: @escaping FirestoreCompletion) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
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
        guard let currentUid = Auth.auth().currentUser?.uid, post.likes > 0 else { return }
        
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
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
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
    
    static func fetchFeedPost(completion: @escaping ([PostModel]) -> ()) {
        guard let current = Auth.auth().currentUser?.uid else { return }
        
        var posts = [PostModel]()
        
        COLLECTION_USERS.document(current)
            .collection(USER_FEED)
            .getDocuments { snapshot, error in
                snapshot?.documents.forEach { doc in
                    fetchPost(with: doc.documentID) { post in
                        posts.append(post)
                        
                        posts.sort { $0.timestamp.seconds > $1.timestamp.seconds }
                        
                        completion(posts)
                    }
                }
            }
    }
    
    static func updateUserFeed(user: String, isFollow: Bool) {
        guard let current = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let docIds = documents.map { $0.documentID }
            
            docIds.forEach { id in
                if isFollow {
                    COLLECTION_USERS.document(current)
                        .collection(USER_FEED)
                        .document(id)
                        .setData([:])
                } else {
                    COLLECTION_USERS.document(current)
                        .collection(USER_FEED)
                        .document(id)
                        .delete()
                }
            }
        }
    }
    
    static func updateUserFeed(postId: String) {
        guard let current = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(current)
            .collection(FOLLOWERS_COLLECTION)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                
                docs.forEach { doc in
                    COLLECTION_USERS.document(doc.documentID)
                        .collection(USER_FEED)
                        .document(postId)
                        .setData([:])
                }
                
                COLLECTION_USERS.document(current)
                    .collection(USER_FEED)
                    .document(postId)
                    .setData([:])
            }
    }
}
