//
//  ProfileHeaderViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 21/07/2021.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: UserModel
    
    var fullName: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl) 
    }
    
    init(user: UserModel) {
        self.user = user
    }
}
