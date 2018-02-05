//
//  LoginViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Change color of placeholder text in textfields
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:0.24, green:0.23, blue:0.22, alpha:1.0)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:0.24, green:0.23, blue:0.22, alpha:1.0)])
        
        // Call to style the text field bottom border
        styleTextFields(textField: usernameTextField)
        styleTextFields(textField: passwordTextField)
        
        // Disable Sign In button unless user input is complete
        setRequiredFields()
        signInButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
        signInButton.isEnabled = false
    }
    
    // MARK: Disable Create Account button unless all fields are completed
    func setRequiredFields() {
        usernameTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
            signInButton.isEnabled = false
            return
        }
        signInButton.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.17, alpha:1.0)
        signInButton.isEnabled = true
    }
    
    // MARK: Dismiss Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Dismiss keyboard when user taps anywhere on screen 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    // MARK: Move view up when user enters text
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y -= 250
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y += 250
        return true
    }
    
    // MARK: Style the text fields to only have a bottom border
    func styleTextFields(textField: UITextField) {
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red:0.24, green:0.23, blue:0.22, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        textField.backgroundColor = UIColor.clear
        
    }
    
    // MARK: IBActions
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "loginToTabBarControllerSegue", sender: nil)
        }
        
    }
    
    
}









