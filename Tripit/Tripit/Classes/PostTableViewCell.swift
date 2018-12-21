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
        
        //self.profileImage.layer.borderColor = bordercolo
    }
    
    public func setPostData(_ post:Post, _ row:Int) {
        locationText.text = post.location
        descriptionText.text = post.description
        likesCounter.text = String(post.likes.count)
        commentsCounter.text = String(post.comments.count)
        mainImage!.tag = row
        
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
    @IBAction func OnCommentSubmit(_ sender: Any) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
