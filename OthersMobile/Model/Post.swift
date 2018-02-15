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
    var id: String?
    
}

extension Post {
    
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        return post
    }
    
}
