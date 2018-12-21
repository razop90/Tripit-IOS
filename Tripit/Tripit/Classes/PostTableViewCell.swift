//
//  PostTableViewCell.swift
//  Tripit
//
//  Created by admin on 14/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import UIKit

class PostTableViewCell : UITableViewCell {
    
    @IBOutlet var userNameText: UILabel!
    @IBOutlet var locationText: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var likesCounter: UILabel!
    @IBOutlet var commentsCounter: UILabel!
    @IBOutlet var descriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 3.0
    }
    
    public func setPostData(_ post:Post, _ row:Int) {
        userNameText.text = ""
        locationText.text = post.location
        descriptionText.text = post.description
        likesCounter.text = String(post.likes.count)
        commentsCounter.text = String(post.comments.count)
        mainImage?.image = UIImage(named: "no_pic")
        profileImage?.image = UIImage(named: "default_profile2")
        mainImage!.tag = row
        profileImage!.tag = row
        
        Model.instance.getUserInfo(post.userID, callback: { (info) in
            if info != nil {
                self.userNameText.text = info?.displayName
            
                if info?.profileImageUrl != "" {
                    Model.instance.getImage(url: info!.profileImageUrl!) { (image:UIImage?) in
                        if (self.profileImage!.tag == row){
                            if image != nil {
                                self.profileImage?.image = image!
                            }
                        }
                    }
                }
            }
        })
        
        if post.imageUrl != "" {
            Model.instance.getImage(url: post.imageUrl!) { (image:UIImage?) in
                if (self.mainImage!.tag == row){
                    if image != nil {
                        self.mainImage?.image = image!
                    }
                }
            }
        }
    }
    
    @IBAction func OnLikeSubmit(_ sender: Any) {
        
    }
}
