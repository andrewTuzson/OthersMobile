//
//  AuthServices.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/6/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthServices {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if error != nil {
                onError(error?.localizedDescription)
                return
            }
            
            // Store profile image in Firebase storage
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child((user?.uid)!)
            
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    
                    // Push user to database
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    self.setUserInformation(profileImageURL: profileImageURL!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
                })
        }
    }
    
    // Push new user information to database
    // Present onboard screen upon completion
    static func setUserInformation(profileImageURL: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["Username" : username, "Email" : email, "profileImageURL" : profileImageURL])
        onSuccess()
    }
    
}
