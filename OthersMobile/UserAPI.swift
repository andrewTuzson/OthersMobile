//
//  UserAPI.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/17/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserAPI {
    
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (UserModel) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                completion(user)
            }
        })
    }
}
