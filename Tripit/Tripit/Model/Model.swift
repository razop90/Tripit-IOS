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
    var sqlModel = SqlModel();
    private var userId:String? = nil
    
    private init() {
    }
    
    func getAllPosts() {
        var lastUpdated = Post.getLastUpdateDate(database: sqlModel.database)
        lastUpdated += 1
        
        firebaseModel.getAllPostsFromDate(from:lastUpdated){ (data:[Post]) in
            self.sqlHandler(data: data) {(isUpdated:Bool, curUserUpdated:Bool) in
                if(isUpdated) {
                    self.getAllPostsFromLocalAndNotify()
                    
                    if(curUserUpdated && self.userId != nil) {
                        self.getAllPostsByUserAndNotify(_userId: self.userId!)
                    }
                }
            }
        }
        
        getAllPostsFromLocalAndNotify()
    }
    
    func getAllPosts(userId:String) {
        self.userId = userId
        
        firebaseModel.getAllPosts(userId: userId){ (data:[Post]) in
            self.sqlHandler(data: data) {(isUpdated:Bool, curUserUpdated:Bool) in
                self.getAllPostsByUserAndNotify(_userId: userId)
            }
        }
        
        getAllPostsByUserAndNotify(_userId: userId)
    }
    
    private func sqlHandler(data:[Post], callback: (Bool, Bool) -> Void) {
        var lastUpdated = Post.getLastUpdateDate(database: sqlModel.database)
        lastUpdated += 1
        var isUpdated = false
        var currUserUpdated = false
        
        for post in data {
            //removing all likes
            Post.removeAllLikes(database: self.sqlModel.database, postId: post.id)
            
            if(post.isDeleted == 1) {
                Post.delete(database: self.sqlModel.database, postId: post.id)
            } else {
                Post.addNew(database: self.sqlModel.database, post: post)
               
                //updating the likes collection
                for like in post.likes {
                    Post.addNewLike(database: self.sqlModel.database, postId: post.id, userId: like)
                }
            }
            
            if(post.lastUpdate > lastUpdated) {
                lastUpdated = post.lastUpdate
                isUpdated = true
            }
           
            
            if(self.userId != nil && post.userID == self.userId!) {
                currUserUpdated = true
            }
        }
        
        if(isUpdated) {
            Post.setLastUpdateDate(database: self.sqlModel.database, date: lastUpdated)
        }
        
        callback(isUpdated, currUserUpdated)
    }
    
    private func getAllPostsFromLocalAndNotify(){
        let postData = Post.getAll(database: self.sqlModel.database)
        NotificationModel.postsListNotification.notify(data: postData)
    }
    
    func getAllPostsByUserAndNotify(_userId:String) {
        let postData = Post.getAll(database: self.sqlModel.database, userId: _userId)
        NotificationModel.userPostsListNotification.notify(data: postData)
    }
    
    func getPostComments(_ postId:String) {
        firebaseModel.getPostComments(postId, callback: {(data:[Post.Comment]) in
            NotificationModel.postsCommentstNotification.notify(data: data)
        })
    }
    
    func updatePost(_ post:Post, _ image:UIImage, _ isImageUpdated:Bool, _ completionBlock:@escaping (_ url:String?) -> Void = {_  in}){
        firebaseModel.updatePost(post, image, isImageUpdated, completionBlock)
    }
    
    func setPostAsDeleted(_ postId:String) {
         firebaseModel.setPostAsDeleted(postId)
    }
    
    func addUserInfo(_ userInfo:UserInfo, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void = {_  in}) {
        firebaseModel.addUserInfo(userInfo, image, completionBlock)
    }
    
    func updateUserInfo(_ userId:String, _ preImageUrl:String?, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void = {_  in}) {
       firebaseModel.updateUserInfo(userId, preImageUrl, image, completionBlock)
    }
    
    func getUserInfo(_ uid:String, callback:@escaping (UserInfo?) -> Void) {
        firebaseModel.getUserInfo(uid) { (info:UserInfo?) in
            if(info != nil) {
                var lastUpdated = UserInfo.getLastUpdateDate(database: self.sqlModel.database)
                lastUpdated += 1;
                
                UserInfo.addNew(database: self.sqlModel.database, info: info!)
                
                if (info!.timestamp > lastUpdated) {
                    lastUpdated = info!.timestamp
                    UserInfo.setLastUpdateDate(database: self.sqlModel.database, date: lastUpdated)
                    self.getUserInfoFromLocalAndNotify(uid, callback)
                }
            }
        }
        
        getUserInfoFromLocalAndNotify(uid, callback)
    }
    
    private func getUserInfoFromLocalAndNotify(_ uid:String, _ callback:@escaping (UserInfo?) -> Void) {
        let info = UserInfo.get(database: self.sqlModel.database, userId: uid)
        if(info != nil) {
            callback(info)
            NotificationModel.userInfoNotification.notify(data: info!)
        }
    }
    
    func addComment(_ postId:String, _ comment:Post.Comment, _ completionBlock:@escaping (_ errorMessage:String?) -> Void = {_  in}) {
        firebaseModel.addComment(postId, comment, completionBlock)
    }
    
    func addLike(_ postId:String, _ userId:String) {
        firebaseModel.addLike(postId, userId)
    }
    
    func removeLike(_ postId:String, _ userId:String) {
        firebaseModel.removeLike(postId, userId)
    }
    
    func getPost(_ byId:String)->Post?{
        return firebaseModel.getPost(byId:byId)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let _url = URL(string: url)
        let localImageName = _url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
            print("got image from cache \(localImageName)")
        }else{
            //2. get the image from Firebase
            firebaseModel.getImage(url: url){(image:UIImage?) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
                print("got image from firebase \(localImageName)")
            }
        }
    }
    
    func saveImageToFile(image:UIImage, name:String){
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    func signIn(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signIn(email, password, callback)
    }
    
    func signOut(_ callback:@escaping () -> Void) {
        firebaseModel.signOut(callback)
    }
    
    func signUp(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signUp(email, password,callback)
    }
    
    func currentUser() -> User? {
        return firebaseModel.currentUser()
    }
}

