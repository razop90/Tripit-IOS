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
    var lastPostId:String?
   // let currentusercheck = userCheck()
    
    
    
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
        cell.setPostData(post)
        
        if self.lastCommentsVC != nil && self.lastPostId == post.id {
                self.lastCommentsVC?.comments = post.comments
                self.lastCommentsVC?.commentsTableView.reloadData()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is CommentsController {
            
            let commentsController = segue.destination as! CommentsController

            let buttonPosition = (sender as AnyObject).convert(CGPoint(), to:postsTableView)
            let indexPath = postsTableView.indexPathForRow(at:buttonPosition)
            let post =  posts[(indexPath?.row)!]
       
            lastPostId = post.id
            lastCommentsVC = commentsController
        
            commentsController.postId = post.id
        }
    }
    
    @IBAction func onLikeSubmit(_ sender: Any) {
        
    }

}
/*func userCheck()->String?{
    let user = Model.instance.currentUser()
    if(user != nil){
        let userEmail = user?.email
        return userEmail
    }
    else{
        return nil
    }
}
*/
