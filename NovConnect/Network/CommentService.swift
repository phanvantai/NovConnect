//
//  CommentService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Foundation
import Firebase

struct CommentService {
    static func uploadComment(comment: String, postId: String, user: UserModel, completion: @escaping FirestoreCompletion) {
        
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postId)
            .collection(COMMENTS_COLLECTION)
            .addDocument(data: data, completion: completion)
    }
    
    static func fetchComment(for postId: String, completion: @escaping ([CommentModel]) -> ()) {
        var comments = [CommentModel]()
        let query = COLLECTION_POSTS.document(postId).collection(COMMENTS_COLLECTION)
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    comments.append(CommentModel(dictionary: change.document.data()))
                }
            }
            completion(comments)
        }
    }
}
