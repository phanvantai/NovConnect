//
//  UserService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Firebase

struct UserService {
    
    static func fetchUser(completion: @escaping (UserModel?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            completion(UserModel(dictionary: data))
        }
    }
}
