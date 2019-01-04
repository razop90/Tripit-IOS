//
//  ProfileViewController.swift
//  Tripit
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 razop. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var postsTableView: UITableView!
    var posts = [Post]()
    var postsListener:NSObjectProtocol?
    
    @IBOutlet var userNameText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        userNameText.text = ""
        profileImageView?.image = UIImage(named: "default_profile2")
        let user = Model.instance.currentUser()
        
        if(user != nil) {
            Model.instance.getUserInfo(user!.uid, callback: { (info) in
                if info != nil {
                    self.userNameText.text = info?.displayName
                    
                    if info?.profileImageUrl != "" {
                        Model.instance.getImage(url: info!.profileImageUrl!) { (image:UIImage?) in
                            if image != nil {
                                self.profileImageView?.image = image!
                            }
                        }
                    }
                }
            })
            
            postsListener = NotificationModel.userPostsListNotification.observe(){
                (data:Any) in
                let newPosts = data as! [Post]
                self.posts = newPosts.sorted { $0.creationDate > $1.creationDate }
                self.postsTableView.reloadData()
            }
            
            Model.instance.getAllPosts(userId: user!.uid)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        let cell:PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.setPostData(post, indexPath.row, false)
        
        return cell
    }
    
    @IBAction func TappedOnBackToMainController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TappedOnSignOut(_ sender: Any) {
        Model.instance.signOut() {() in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            //Getting the navigation controller
            guard let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            //Navigate to the main view
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
