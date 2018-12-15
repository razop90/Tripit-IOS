//
//  MainDisplayController.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit

class  MainDisplayController : UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet var postsTableView: UITableView!
    var posts = [Post]()
    var postsListener:NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsListener = NotificationModel.postsListNotification.observe(){
            (data:Any) in
            let newPosts = data as! [Post]
            self.posts = newPosts.sorted { $0.creationDate > $1.creationDate }
            self.postsTableView.reloadData()
        }
        Model.instance.getAllPosts()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cell.textLabel?.text = list[indexPath.row]
        let cell:PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        
        let post = posts[indexPath.row]
        cell.locationText.text = post.location
        cell.descriptionText.text = post.description
        cell.likesCounter.text = String(post.likes.count)        
        
        //cell.profileImage?.image = UIImage(named: "default_profile2.jpg")
        if post.imageUrl != "" {
                Model.instance.getImage(url: post.imageUrl!) { (image:UIImage?) in
                    if image != nil {
                        cell.mainImage?.image = image!
                    }
                }
         }
        
        return cell
    }
    
}
