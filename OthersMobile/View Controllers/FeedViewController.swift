//
//  ViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class FeedViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dynamically set cell height. Doesn't work and I think it's my constraints?
        // tableView.estimatedRowHeight = 521
        // tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        loadPosts()
    }

    func loadPosts() {
        activityIndicatorView.stopAnimating()
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict)
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        }
        
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
    
    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CommentSegue", sender: nil)
    }
    

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
}

