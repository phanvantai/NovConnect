//
//  UserCellViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 22/07/2021.
//

import Foundation

struct UserCellViewModel {
    
    // MARK: - Properties
    private var user: UserModel
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    init(user: UserModel) {
        self.user = user
    }
}
