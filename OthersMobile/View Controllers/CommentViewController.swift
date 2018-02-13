//
//  CommentViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/12/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    let postId = "placeholder_reference"
    var comments = [Comment]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // MARK: Set up notification center to handle moving the view when the keyboard is presented
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        sendCommentButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
        sendCommentButton.isEnabled = false
        setRequiredFields()
        loadComments()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
            
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadComments() {
        let postCommentRef = Database.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            Database.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComment in
                if let dict = snapshotComment.value as? [String: Any] {
                    let newComment = Comment.transformComment(dict: dict)
                    self.fetchUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                }
            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
    }
    
    // MARK: Disable Send button unless text field has a comment
    func setRequiredFields() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendCommentButton.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.17, alpha:1.0)
            sendCommentButton.isEnabled = true
            return
        }
        sendCommentButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
        sendCommentButton.isEnabled = false
    }
    
    // MARK: IBActions
    @IBAction func sendButtonPressed(_ sender: Any) {
        let ref = Database.database().reference()
        let commentReference = ref.child("comments")
        let newCommentID = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentID)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let postCommentRef = Database.database().reference().child("post-comments").child(self.postId).child(newCommentID)
            self.empty()
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
        })
    }
    
    func empty() {
        commentTextField.text = ""
        sendCommentButton.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.84, alpha:1.0)
        sendCommentButton.isEnabled = false
    }
    
}


extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
}









