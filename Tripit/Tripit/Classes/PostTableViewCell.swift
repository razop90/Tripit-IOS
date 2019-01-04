//
//  PostTableViewCell.swift
//  Tripit
//
//  Created by admin on 14/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func opacity(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

class PostTableViewCell : UITableViewCell {
    private var lastPostId:String = ""
    private var lastPostLikes:[String] = [String]()
    
    @IBOutlet var userNameText: UILabel!
    @IBOutlet var locationText: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var likesCounter: UILabel!
    @IBOutlet var commentsCounter: UILabel!
    @IBOutlet var descriptionText: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(self.profileImage != nil && self.profileImage.image != nil) {
            // Initialization code
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            self.profileImage.clipsToBounds = true
         self.profileImage.layer.borderWidth = 3.0
        }
    }
    
    public func setPostData(_ post:Post, _ row:Int, _ isUserSet:Bool = true) {
        //saving the last post details
        lastPostId = post.id
        lastPostLikes = post.likes
        
        locationText.text = post.location
        descriptionText.text = post.description
        likesCounter.text = String(post.likes.count)
        commentsCounter.text = String(post.comments.count)
        mainImage?.image = UIImage(named: "no_pic")      
        mainImage!.tag = row
        
        //setting a like image depends on the user like state.
        let user = Model.instance.currentUser()
        var img = UIImage(named: "like_unpressed")
        if(user != nil) {
            if(lastPostLikes.contains(user!.uid)) {
                  img = UIImage(named: "like_pressed")
            }
        }
        likeButton.setImage(img, for: .normal)
        
        if(isUserSet) {
            userNameText.text = ""
            profileImage?.image = UIImage(named: "default_profile2")
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
        }
        
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
        let user = Model.instance.currentUser()
        if(user != nil) {
            if(lastPostLikes.contains(user!.uid)) {
                 Model.instance.removeLike(lastPostId, user!.uid)
            }
            else {
                 Model.instance.addLike(lastPostId, user!.uid)
            }
        }
     }
}
