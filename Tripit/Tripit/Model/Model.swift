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
    
    func addNewPost(_ post:Post, _ image:UIImage, _ completionBlock:@escaping (_ url:String?) -> Void = {_  in}){
        firebaseModel.addNewPost(post, image, completionBlock);
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
    
    func saveImage(image:UIImage, callback:@escaping (String?)->Void){
        firebaseModel.saveImage(image: image, callback: callback)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        //modelFirebase.getImage(url: url, callback: callback)
        
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
    
    func signUp(_ email:String, _ password:String, _ callback:@escaping (Bool)->Void)
    {
        firebaseModel.signUp(email, password,callback)
    }
    
    func currentUser() -> User? {
        return firebaseModel.currentUser()
    }
}

