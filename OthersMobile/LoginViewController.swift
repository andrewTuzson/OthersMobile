//
//  LoginViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        view.frame.origin.y -= 300
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y += 300
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
    
    
}
