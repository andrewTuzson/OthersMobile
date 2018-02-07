//
//  AddPostViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/7/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCaption: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            ProgressHUD.show("Hold up...", interaction: false)
            let photoID = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoID)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                // Push user to database
                let photoURL = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoURL: photoURL!)
            })
            
        } else {
            ProgressHUD.showError("Select a profile image.")
        }
        
    }
    
    func sendDataToDatabase(photoURL: String) {
        
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostID = postsReference.childByAutoId().key
        let newpostReference = postsReference.child(newPostID)
        newpostReference.setValue(["photoURL": photoURL], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Laced it")
        })
        
    }
    

}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            postImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
