//
//  FirebaseModel.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class FirebaseModel {
    var ref: DatabaseReference!
    lazy var storageRef = Storage.storage().reference(forURL:
        "gs://tripit-65d75.appspot.com")
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
    }
    
    func getAllPosts(callback:@escaping ([Post]) -> Void) {
        //Listening to table changes. same as while(true)
        ref.child(Consts.Posts.PostsTableName).observe(.value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                // Get user value
                var data = [Post]()
                
                let value = snapshot.value as! [String:Any]
                for (_, json) in value{
                    data.append(Post(json: json as! [String : Any]))
                }
                callback(data)
            }
        })
    }
    
    func getAllPostsFromDate(from:Double, callback:@escaping ([Post])->Void) {
        let stRef = ref.child("Posts")
        let fbQuery = stRef.queryOrdered(byChild: "lastUpdate").queryStarting(atValue: from)
        fbQuery.observe(.value) { (snapshot) in
            var data = [Post]()
            if let value = snapshot.value as? [String:Any] {
                for (_, json) in value{
                    data.append(Post(json: json as! [String : Any]))
                }
            }
            callback(data)
        }
    }
    
    func getPostComments(_ postId:String, callback:@escaping ([Post.Comment]) -> Void) {
        //Listening to table changes. same as while(true)
        ref.child(Consts.Posts.PostsTableName).child(postId).child(Consts.Posts.CommentsTableName).observe(.value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                // Get user value
                var data = [Post.Comment]()
                
                let value = snapshot.value as! [String:Any]
                for (key, json) in value{
                    data.append(Post.Comment(key, json as! [String:Any]))
                }
                callback(data)
            }
        })
    }
    
    func addNewPost(_ post:Post, _ image:UIImage?, _ completionBlock:@escaping (_ url:String?) -> Void = {_  in}) {
        
        if image != nil {
            saveImage(folderName: Consts.Posts.ImagesFolderName, image: image!) { (url:String?) in
                if url != nil {
                    post.imageUrl = url!
                }
                
                let newPostRef = self.ref!.child(Consts.Posts.PostsTableName).childByAutoId()
                post.id = newPostRef.key!
                
                newPostRef.setValue(post.toJson())
                
                completionBlock(url)
            }
        }
    }
    
    func addUserInfo(_ userInfo:UserInfo, _ image:UIImage?, _ completionBlock:@escaping (Bool) -> Void = {_  in}) {
        if image != nil {
            saveImage(folderName: Consts.Posts.ProfileImagesFolderName, image: image!) { (url:String?) in
                if url != nil {
                    userInfo.profileImageUrl = url!
                }
                
                self.ref!.child(Consts.Posts.UserInfoTableName).child(userInfo.uid).setValue(userInfo.toJson())
                completionBlock(true)
            }
        }
        else {
            self.ref!.child(Consts.Posts.UserInfoTableName).child(userInfo.uid).setValue(userInfo.toJson())
            completionBlock(true)
        }
    }
    
    func getUserInfo(_ uid:String, callback:@escaping (UserInfo?) -> Void) {
        self.ref!.child(Consts.Posts.UserInfoTableName).child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                let value = snapshot.value as! [String:Any]
                let userInfo = UserInfo(_uid: uid, json: value)
                
                callback(userInfo)
            }
            else {
                callback(nil)
            }
        })
    }
    
    func getPost(byId:String) -> Post? {
        return nil
    }
    
    func addComment(_ postId:String, _ comment:Post.Comment, _ completionBlock:@escaping (_ errorMessage:String?) -> Void = {_  in}) {
        let newCommentRef = self.ref!.child(Consts.Posts.PostsTableName).child(postId).child(Consts.Posts.CommentsTableName).childByAutoId()
        comment.id = newCommentRef.key!

        newCommentRef.setValue(comment.toJson())
        //updating the comment's post update time
        self.ref!.child(Consts.Posts.PostsTableName).child(postId).child("lastUpdate").setValue(ServerValue.timestamp())
    }
    
    func addLike(_ postId:String, _ userId:String) {
        
    }
    
    func saveImage(folderName:String, image:UIImage, callback:@escaping (String?) -> Void) {
        let data = image.jpegData(compressionQuality: 0.8)
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageRef = storageRef.child(folderName).child(imageName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(url:String, callback:@escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    func signUp(_ email:String, _ password:String, _ callback:@escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if authResult?.user != nil {
                
                let email = authResult!.user.email!
                let display = (email.components(separatedBy: "@"))[0]
                
                let userInfo = UserInfo(_uid: authResult!.user.uid, _displayName: display, _email: email, _profileImageUrl: nil)
                self.addUserInfo(userInfo, nil, { (val) in
                    print("1")
                    callback(true)
                })
            }
            else {
                print("0")
                callback(false)
            }
        }
    }    
    
    func signIn(_ email:String, _ password:String, _ callback:@escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (user != nil  ) {
                callback(true)
            }
            else {
                callback(false)
            }
        }
    }
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    
   
}
