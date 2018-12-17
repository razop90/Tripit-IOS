//
//  CommentViewCell.swift
//  Tripit
//
//  Created by admin on 16/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import UIKit

class CommentViewCell : UITableViewCell {
    
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        //self.profileImageView.layer.borderWidth = 3.0
        
        //self.profileImage.layer.borderColor = bordercolo
    }
    
    public func setCommentData(_ comment:Post.Comment) {
        commentText.text = comment.comment
        userNameText.text = comment.userId
        timeText.text = comment.creationDate
    }
}
