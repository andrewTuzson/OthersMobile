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

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postId: String!
    var comments = [Comment]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        commentTextField.delegate = self
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
    
    // MARK: Dismiss Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Dismiss keyboard when user taps anywhere on screen
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += keyboardFrame!.height
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
        API.Post_Comments.REF_POST_COMMENTS.child(self.postId).observe(.childAdded, with: {
            snapshot in
            API.Comment.observeComments(withPostId: snapshot.key, completion: {
                comment in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        API.User.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
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
        let commentReference = API.Comment.REF_COMMENTS
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
            
            let postCommentRef = API.Post_Comments.REF_POST_COMMENTS.child(self.postId).child(newCommentID)
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









