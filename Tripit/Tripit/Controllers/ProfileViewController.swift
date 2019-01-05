//
//  ProfileViewController.swift
//  Tripit
//
//  Created by admin on 04/01/2019.
//  Copyright © 2019 razop. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var postsTableView: UITableView!
    @IBOutlet var busyIndicator: UIActivityIndicatorView!
    @IBOutlet var userNameText: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    var posts = [Post]()
    var postsListener:NSObjectProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapDetected))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(singleTap)
        
        self.busyIndicator.isHidden = true
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true

        userNameText.text = ""
        let image = UIImage(named: "default_profile2")
        profileImageView.image = image

        let user = Model.instance.currentUser()
        
        if(user != nil) {
            Model.instance.getUserInfo(user!.uid, callback: { (info) in
                if info != nil {
                    self.userNameText.text = info?.displayName
                    
                    if info?.profileImageUrl != "" {
                        Model.instance.getImage(url: info!.profileImageUrl!) { (image:UIImage?) in
                            if image != nil {
                                self.profileImageView.image = image
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
        //Create the alert controller and actions
        let alert = UIAlertController(title: "Sign Out", message: "That's it?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            DispatchQueue.main.async {
                Model.instance.signOut() {() in
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    guard let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                        return
                    }
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
        
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.destination is AddPostController {
            
            let addPostController = segue.destination as! AddPostController
            
            let buttonPosition = (sender as AnyObject).convert(CGPoint(), to:postsTableView)
            let indexPath = postsTableView.indexPathForRow(at:buttonPosition)
            let post =  posts[(indexPath?.row)!]
            
            addPostController.enterEditMode(post: post)
        }
    }
    
    @objc func tapDetected(){
        showImagePicker()
    }
    
    @objc private func showImagePicker(){
        //Creating an instance of the image picker controller and using it
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Cloasing the picker in case of a cancelation request from the user
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //If the user picked an image, wer'e grabbing the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            busyIndicator.startAnimating()
            busyIndicator.isHidden = false
            self.view.isUserInteractionEnabled = false

            let user = Model.instance.currentUser()
             if(user != nil) {
                Model.instance.getUserInfo(user!.uid, callback: {(userInfo:UserInfo?) in
                    if (userInfo != nil) {
                        Model.instance.updateUserInfo(userInfo!.uid, userInfo!.profileImageUrl, image, {(res:Bool) in
                            if(res == true) {
                                self.profileImageView.image = image
                            } else {
                                self.present(Consts.General.getCancelAlertController(title: "Profile Image", messgae: "Error while uploading the image"), animated: true)
                            }
                            
                            self.busyIndicator.stopAnimating()
                            self.busyIndicator.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        })
                    } else {
                        self.present(Consts.General.getCancelAlertController(title: "Profile Image", messgae: "Error while uploading profile image"), animated: true)
                        
                        self.busyIndicator.stopAnimating()
                        self.busyIndicator.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    }
                })
            }
        } else {
            present(Consts.General.getCancelAlertController(title: "Profile Image", messgae: "Error while selecting an image"), animated: true)
            
            busyIndicator.stopAnimating()
            busyIndicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
