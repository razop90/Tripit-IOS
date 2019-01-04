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
    
    private init(){
    }
    
    func getAllPosts() {
        var lastUpdated = Post.getLastUpdateDate(database: sqlModel.database)
        lastUpdated += 1;
        var isUpdated = false
        
        firebaseModel.getAllPostsFromDate(from:lastUpdated){ (data:[Post]) in
            for post in data {
                Post.addNew(database: self.sqlModel.database, post: post)
               
                //removing all likes and updating the likes collection.
                Post.removeAllLikes(database: self.sqlModel.database, postId: post.id)
                for like in post.likes {
                    Post.addNewLike(database: self.sqlModel.database, postId: post.id, userId: like)
                }
                
                if (post.lastUpdate > lastUpdated) {
                    lastUpdated = post.lastUpdate
                    isUpdated = true
                }
            }
            
            if(isUpdated) {
                Post.setLastUpdateDate(database: self.sqlModel.database, date: lastUpdated)
                self.getAllPostsFromLocalAndNotify()
            }
        }
        
        getAllPostsFromLocalAndNotify()
    }
    
    private func getAllPostsFromLocalAndNotify(){
        let postData = Post.getAll(database: self.sqlModel.database)
        NotificationModel.postsListNotification.notify(data: postData)
    }
    
    func getPostComments(_ postId:String) {
        firebaseModel.getPostComments(postId, callback: {(data:[Post.Comment]) in
            NotificationModel.postsCommentstNotification.notify(data: data)
        })
    }
    
    func addNewPost(_ post:Post, _ image:UIImage, _ completionBlock:@escaping (_ url:String?) -> Void = {_  in}){
        firebaseModel.addNewPost(post, image, completionBlock)
    }
    
    func addUserInfo(_ userInfo:UserInfo, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void = {_  in}) {
        firebaseModel.addUserInfo(userInfo, image, completionBlock)
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

