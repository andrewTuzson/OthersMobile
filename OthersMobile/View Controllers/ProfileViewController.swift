//
//  ProfileViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/5/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBActions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginScreenVC") as! LoginViewController
        present(loginVC, animated: true, completion: nil)
    }
    

}
