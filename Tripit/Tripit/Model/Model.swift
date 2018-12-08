//
//  Model.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation

class Model {
    static let instance:Model = Model()
    let postsListNotification = "com.menachi.postslist"
    var firebaseModel = FirebaseModel();
    let imageUploadManager = ImageUploadManager()
    
    private init(){
    }
    
    
    func getAllPosts() {
        firebaseModel.getAllPosts(callback: {(data:[Post]) in
            NotificationCenter.default.post(name: NSNotification.Name(self.postsListNotification),
                                            object: self,
                                            userInfo: ["data":data])
            
        })
    }
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        firebaseModel.getAllPosts(callback: callback);
        //return Student.getAll(database: modelSql!.database);
    }
    
    func addNewPost(post:Post, progressBlock: @escaping (_ presentage: Double) -> Void = {_ in}, _ completionBlock:@escaping (_ url:URL?, _ errorMessage:String?) -> Void = {_,_  in}){
        firebaseModel.addNewPost(post: post, progressBlock: progressBlock, completionBlock);
        //Student.addNew(database: mo delSql!.database, student: student)
    }
    
    func getPost(byId:String)->Post?{
        return firebaseModel.getPost(byId:byId)
        //return Student.get(database: modelSql!.database, byId: byId);
    }
}

