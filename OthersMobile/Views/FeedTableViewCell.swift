//
//  FeedTableViewCell.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/10/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func setupUserInfo() {
        if let uid = post?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let user = UserModel.transformUser(dict: dict)
                    self.nameLabel.text = user.username
                    if let photoUrlString = user.profileImageUrl {
                        let photoUrl = URL(string: photoUrlString)
                        self.profileImageView.sd_setImage(with: photoUrl)
                    }
                }
            })
        }
    }
    
    func updateView() {
        captionLabel.text = post?.caption
        if let photoUrlString = post?.photoURL {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        setupUserInfo()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
