//
//  Model.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Model {
    static let instance:Model = Model()
    
    var firebaseModel = FirebaseModel();
    
    private init(){
    }
    
    func getAllPosts() {
        firebaseModel.getAllPosts(callback: {(data:[Post]) in
            NotificationModel.postsListNotification.notify(data: data)            
        })
    }
    
    func getPostComments(_ postId:String) {
        firebaseModel.getPostComments(postId, callback: {(data:[Post.Comment]) in
            NotificationModel.postsCommentstNotification.notify(data: data)
        })
    }
    
    func addNewPost(_ post:Post, _ image:UIImage, progressBlock: @escaping (_ presentage: Double) -> Void = {_ in}, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void = {_,_  in}){
        firebaseModel.addNewPost(post, image, progressBlock: progressBlock, completionBlock);
    }
    
    func addComment(_ postId:String, _ comment:Post.Comment, _ completionBlock:@escaping (_ errorMessage:String?) -> Void = {_  in}) {
        firebaseModel.addComment(postId, comment, completionBlock)
    }
    
    func addLike(_ postId:String, _ userId:String) {
        firebaseModel.addLike(postId, userId)
    }
    
    func getPost(_ byId:String)->Post?{
        return firebaseModel.getPost(byId:byId)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        firebaseModel.getImage(url: url, callback: callback)
    }
    func signIn(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signIn(email, password, callback)
    }
    
    func signUp(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signUp(email, password,callback)
    }
    
    func currentUser()->User?{
        return firebaseModel.CurrentUser()
    }
}

