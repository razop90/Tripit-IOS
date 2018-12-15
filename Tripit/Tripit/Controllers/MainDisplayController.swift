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
        
        cell.setPostData(posts[indexPath.row])
        
        return cell
    }
    
}
