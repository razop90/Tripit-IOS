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
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        
    }
    
    func getAllPosts(callback:@escaping ([Post])->Void){
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
    
    func addNewPost(_ post:Post, _ image:UIImage?, progressBlock: @escaping (_ presentage: Double) -> Void = {_ in}, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void = {_,_  in}){
        if image != nil {
            uploadImage(image!, progressBlock:progressBlock, { (fileURL, errorMessage) in
                
                print(fileURL ?? "no URL was found")
                print(errorMessage ?? "no error exist")
                post.imageUrl = fileURL?.absoluteString
                
                let newPostRef = self.ref!.child(Consts.Posts.PostsTableName).childByAutoId()
                post.id = newPostRef.key!
                
                newPostRef.setValue(post.toJson())
                
                completionBlock(fileURL, errorMessage)
            })
        }
        
      
    }
    
    func getPost(byId:String)->Post?{
        return nil
    }
    
    func addComment(_ postId:String, _ comment:Post.Comment) {
        
    }
    
    func addLike(_ postId:String, _ userId:String) {
        
    }
    
    func uploadImage(_ image:UIImage, progressBlock: @escaping (_ presentage: Double) -> Void, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void) -> Void {
        //var returnedURL: URL? = nil
        let storage = Storage.storage() //The birebase storage object
        let storageReference = storage.reference() //The firebase storage reference
        
        //Storage/postsImages/{customID}/image.jpg
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imageReference = storageReference.child(Consts.Posts.ImagesFolderName).child(imageName)
        
        //Starting the upload - trying to convert the image into Data by 0.8% quality
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg" //Letting firebase to know the we want to uplad an image
            //Uploading the image Data
            let uploadTask = imageReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if metadata != nil {
                    imageReference.downloadURL{ url, error in
                        //Returning the URL and return errors if exist
                        completionBlock(url, error?.localizedDescription)
                        //returnedURL = url
                    }
                } else {
                    //No URL was found
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            //Getting the upload progress Data of the image
            uploadTask.observe(.progress, handler: { (snapshot) in
                //Checking if there is a progress in order to update the progress
                guard let progress = snapshot.progress else {
                    return
                }
                
                let precentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(precentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
        
        //return returnedURL
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
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

}



