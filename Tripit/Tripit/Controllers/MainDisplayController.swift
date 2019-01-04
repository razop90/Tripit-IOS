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
    var lastCommentsVC:CommentsController?
    
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
        let cell:PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.setPostData(post, indexPath.row)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is CommentsController {
            
            let commentsController = segue.destination as! CommentsController
            
            let buttonPosition = (sender as AnyObject).convert(CGPoint(), to:postsTableView)
            let indexPath = postsTableView.indexPathForRow(at:buttonPosition)
            let post =  posts[(indexPath?.row)!]
            
            lastCommentsVC = commentsController
            commentsController.postId = post.id
            commentsController.comments = post.comments
        }
    }
}
