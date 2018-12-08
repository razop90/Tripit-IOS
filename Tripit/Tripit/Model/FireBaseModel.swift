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

class FirebaseModel {
    var ref: DatabaseReference!
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        
    }
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        //        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
        //            // Get user value
        //            var data = [Posts]()
        //            let value = snapshot.value as! [String:Any]
        //            for (_, json) in value{
        //                data.append(Post(json: json as! [String : Any]))
        //            }
        //            callback(data)
        //        }) { (error) in
        //            print(error.localizedDescription)
        //        }
        
        //Listening to table changes. same as while(true)
        ref.child(Consts.Posts.PostsTableName).observe(.value, with: {
            (snapshot) in
            // Get user value
            var data = [Post]()
            let value = snapshot.value as! [String:Any]
            for (_, json) in value{
                data.append(Post(json: json as! [String : Any]))
            }
            callback(data)
        })
    }
    
    func addNewPost(post:Post,  progressBlock: @escaping (_ presentage: Double) -> Void = {_ in}, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void = {_,_  in}){
         if let image = post.image {
            Model.instance.imageUploadManager.UploadImage(image, progressBlock:progressBlock, { (fileURL, errorMessage) in
                
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

}



