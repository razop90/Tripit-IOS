//
//  Model.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        firebaseModel.getAllPosts(callback: callback);
        //return Student.getAll(database: modelSql!.database);
    }
    
    func addNewPost(_ post:Post, _ image:UIImage, progressBlock: @escaping (_ presentage: Double) -> Void = {_ in}, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void = {_,_  in}){
        firebaseModel.addNewPost(post, image, progressBlock: progressBlock, completionBlock);
        //Student.addNew(database: mo delSql!.database, student: student)
    }
    
    func addComment(_ postId:String, _ comment:Post.Comment) {
        firebaseModel.addComment(postId, comment)
    }
    
    func addLike(_ postId:String, _ userId:String) {
        firebaseModel.addLike(postId, userId)
    }
    
    func getPost(_ byId:String)->Post?{
        return firebaseModel.getPost(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        firebaseModel.getImage(url: url, callback: callback)
    }
}

