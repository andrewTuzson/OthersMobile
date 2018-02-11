//
//  Post.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/8/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import Foundation

class Post {
    
    var caption: String?
    var photoURL: String?
    var uid: String?
    
}

extension Post {
    
    static func transformPost(dict: [String: Any]) -> Post {
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
    
}
