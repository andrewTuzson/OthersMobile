//
//  CommentTableViewCell.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/12/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: UserModel? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        commentLabel.text = comment?.commentText
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "profileIcon2"))
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        nameLabel.text = ""
        commentLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "profileIcon2")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
