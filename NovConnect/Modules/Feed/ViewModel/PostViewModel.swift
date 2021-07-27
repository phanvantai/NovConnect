//
//  PostViewModel.swift
//  NovConnect
//
//  Created by Tai Phan Van on 27/07/2021.
//

import Foundation

struct PostViewModel {
    var post: PostModel
    
    var imageUrl: URL? { URL(string: post.imageUrl) }
    
    var isLiked: Bool { post.isLiked }
    
    var caption: String { post.caption }
    
    var likes: String {
        switch post.likes {
        case 0:
            return ""
        case 1:
            return "\(post.likes) like"
        default:
            return "\(post.likes) likes"
        }
    }
    
    var ownerUsername: String { post.ownerUsername }
    
    var ownerProfileImageUrl: URL? { URL(string: post.ownerProfileImageUrl) }
    
    init(post: PostModel) {
        self.post = post
    }
}
