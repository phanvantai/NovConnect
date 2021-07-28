//
//  UserService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Firebase

struct UserService {
    
    static func fetchUser(with uid: String, completion: @escaping (UserModel?) -> ()) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            completion(UserModel(dictionary: data))
        }
    }
    
    static func fetchUsers(completion: @escaping ([UserModel]?) -> ()) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            let users = snapshot.documents.map { UserModel(dictionary: $0.data())}
            completion(users)
        }
    }
    
    static func follow(user: String, completion: @escaping (Bool) -> ()) {
        guard let current = Auth.auth().currentUser?.uid else {
            print("\(#function) no current user")
            completion(false)
            return
        }
        COLLECTION_FOLLOWING.document(current)
            .collection(FOLLOWING_COLLECTION)
            .document(user)
            .setData([:]) { error in
                if let error = error {
                    print("\(#function) \(error.localizedDescription)")
                    completion(false)
                } else {
                    COLLECTION_FOLLOWERS.document(user)
                        .collection(FOLLOWERS_COLLECTION)
                        .document(current)
                        .setData([:]) { error in
                            if let error = error {
                                print("\(#function) \(error.localizedDescription)")
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                }
            }
    }
    
    static func unfollow(user: String, completion: @escaping (Bool) -> ()) {
        guard let current = Auth.auth().currentUser?.uid else {
            print("\(#function) no current user")
            completion(false)
            return
        }
        COLLECTION_FOLLOWING.document(current)
            .collection(FOLLOWING_COLLECTION)
            .document(user)
            .delete { error in
                if let error = error {
                    print("\(#function) \(error.localizedDescription)")
                    completion(false)
                } else {
                    COLLECTION_FOLLOWERS.document(user)
                        .collection(FOLLOWERS_COLLECTION)
                        .document(current)
                        .delete { error in
                            if let error = error {
                                print("\(#function) \(error.localizedDescription)")
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                }
            }
    }
    
    static func checkIfUserIsFollowing(user: String, completion: @escaping (Bool) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("\(#function) no current user")
            completion(false)
            return
        }
        COLLECTION_FOLLOWING.document(currentUid)
            .collection(FOLLOWING_COLLECTION)
            .document(user)
            .getDocument { snapshot, error in
                if let isFollowing = snapshot?.exists {
                    completion(isFollowing)
                } else {
                    completion(false)
                }
        }
    }
    
    static func fetchFollowers(of user: UserModel, completion: @escaping (Int) -> ()) {
        COLLECTION_FOLLOWERS.document(user.uid)
            .collection(FOLLOWERS_COLLECTION)
            .getDocuments { snapshot, error in
                if let followers = snapshot?.documents.count {
                    completion(followers)
                } else {
                    completion(0)
                }
            }
    }
    
    static func fetchFollowing(of user: UserModel, completion: @escaping (Int) -> ()) {
        COLLECTION_FOLLOWING.document(user.uid)
            .collection(FOLLOWING_COLLECTION)
            .getDocuments { snapshot, error in
                if let following = snapshot?.documents.count {
                    completion(following)
                } else {
                    completion(0)
                }
            }
    }
}
