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
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
    }
    
    public func setCommentData(_ comment:Post.Comment, _ row:Int) {
        userNameText.text = ""
        commentText.text = comment.comment
        timeText.text = comment.lastUpdate
        profileImageView?.image = UIImage(named: "default_profile2")
        profileImageView!.tag = row
        
        Model.instance.getUserInfo(comment.userId, callback: { (info) in
              if info != nil {
                self.userNameText.text = info?.displayName
            
                if info?.profileImageUrl != "" {
                    Model.instance.getImage(url: info!.profileImageUrl!) { (image:UIImage?) in
                        if (self.profileImageView!.tag == row){
                            if image != nil {
                                self.profileImageView?.image = image!
                            }
                        }
                    }
                }
            }
        })
    }
}
