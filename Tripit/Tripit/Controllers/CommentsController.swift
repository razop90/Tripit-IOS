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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let singleTap = UITapGestureRecognizer(target: self, action: #selector(CommentsController.tableTapDetected))
        //self.commentsTableView!.addGestureRecognizer(singleTap)
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
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.dockViewHeightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell:CommentViewCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        
        cell.setCommentData(comments[indexPath.row])
        
        return cell
        
    }
    
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBAction func OnSendCommentSubmit(_ sender: Any) {
        self.commentText.endEditing(true)
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
