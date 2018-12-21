//
//  CommentsController.swift
//  Tripit
//
//  Created by admin on 16/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import UIKit


class CommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var comments = [Post.Comment]()
    var commentsListener:NSObjectProtocol?
    var postId:String?
    
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable send button as a default value
        sendButton.isEnabled = false
        //add tap gesture to the tableView
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(CommentsController.tableTapDetected))
        commentsTableView.addGestureRecognizer(singleTap)
        //add a listner to comments list of a specific post
        commentsListener = NotificationModel.postsCommentstNotification.observe(){
            (data:Any) in
            let newComments = data as! [Post.Comment]
            self.comments = newComments.sorted { $0.timestamp > $1.timestamp }
            self.commentsTableView.reloadData()
        }
        Model.instance.getPostComments(postId!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationModel.postsCommentstNotification.remove(observer: commentsListener!)
    }
    
    @objc func tableTapDetected() {
        self.commentText.endEditing(true)
    }
    
    //MARK: text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.dockViewHeightConstraint.constant = 370
            self.view.layoutIfNeeded()
        }, completion: { (ok) in
            if ok {
                self.sendButton.isEnabled = true
            }})
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.dockViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }, completion: { (ok) in
            if ok {
                self.sendButton.isEnabled = false
            }})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        
        cell.setCommentData(comments[indexPath.row])
        
        return cell
    }
    
    @IBAction func OnSendCommentSubmit(_ sender: Any) {
        if !(self.commentText!.text?.isEmpty)! {
            Model.instance.addComment(self.postId!, Post.Comment("User Id", self.commentText!.text!))
            
            commentText!.text = ""
            self.sendButton.isEnabled = false
            self.commentText.endEditing(true)
        }
        else {
            self.present(Consts.General.getCancelAlertController(title: "Invalid Comment", messgae: "Please type a comment in the text field below"), animated: true, completion: nil)
        }
    }
}
