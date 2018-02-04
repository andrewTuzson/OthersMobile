//
//  CreateAccountViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: Return user to Login screen
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Dismiss keyboard when user taps anywhere on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Dismiss keyboard when user taps Done button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Move view up when user enters texts
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y -= 250
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y += 250
        return true
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user: User?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            let ref = Database.database().reference()
            let userReference = ref.child("users")
            let uid = user?.uid
            let newUserReference = userReference.child(uid!)
            newUserReference.setValue(["Username" : self.usernameTextField.text!, "Email" : self.emailTextField.text!])
        }
    }
    
    
}










