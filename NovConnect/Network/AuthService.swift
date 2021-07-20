//
//  AuthService.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import UIKit
import Firebase

struct AuthCredential {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func register(withCredential credential: AuthCredential, completion: @escaping (Error?) -> ()) {
        ImageUploader.upload(image: credential.profileImage) { result in
            switch result {
            case .success(let url):
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
                    if let error = error {
                        print("\(#function) \((error.localizedDescription))")
                        completion(error)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let data: [String: Any] = ["email": credential.email,
                                               "uid": uid,
                                               "profileImageUrl": url,
                                               "fullname": credential.fullname,
                                               "username": credential.username]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}
