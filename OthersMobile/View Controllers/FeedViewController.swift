//
//  ViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/3/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadPosts()
    }

    func loadPosts() {
        
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict)
                self.posts.append(newPost)
                self.tableView.reloadData()
            }
        }
        
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
}

