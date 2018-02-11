//
//  UserModel.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/11/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension UserModel {
    static func transformUser(dict: [String: Any]) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageURL"] as? String
        user.username = dict["Username"] as? String
        
        return user
    }
}
