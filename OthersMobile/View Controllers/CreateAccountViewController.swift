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
import FirebaseStorage

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Round corners of profile image
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        // Create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.handleSelectProfileImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        // Configure and disable Create Account button until fields are complete
        createAccountButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
        createAccountButton.isEnabled = false
        setRequiredFields()
    }
    
    // MARK: Disable Create Account button unless all fields are completed
    func setRequiredFields() {
        emailTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        usernameTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            createAccountButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
            createAccountButton.isEnabled = false
            return
        }
        createAccountButton.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.17, alpha:1.0)
        createAccountButton.isEnabled = true
    }
    
    // MARK: Handle profile image tap gestures
    @objc func handleSelectProfileImageView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthServices.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                self.performSegue(withIdentifier: "createAccountToPageViewControllerSegue", sender: nil)
            }, onError: { (errorString) in
                print(errorString!)
            })
        } else {
            print("Profile image can't be empty")
        }
    }
    
}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}










