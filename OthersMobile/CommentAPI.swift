//
//  CommentAPI.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/17/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentAPI {
    
    var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
}
