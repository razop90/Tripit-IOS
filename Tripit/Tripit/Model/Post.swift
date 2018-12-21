//
//  Post.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    var id:String
    let userID:String
    let location:String
    let description:String
    var lastUpdate:String
    var timestamp:Double
    var imageUrl:String?
    var likes:[String] //contains user id's
    var comments:[Comment]
    
    init(_userID:String, _id:String, _location:String, _description:String, _imageUrl:String? = nil){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = _imageUrl
        likes = [String]()
        comments = [Comment]()
        lastUpdate = ""
        timestamp = 0
    }
    
    init(_userID:String, _id:String, _location:String, _description:String){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = nil
        likes = [String]()
        comments = [Comment]()
        lastUpdate = ""
        timestamp = 0
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        userID = json["userID"] as! String
        location = json["location"] as! String
        description = json["description"] as! String
        imageUrl = json["imageUrl"] as? String
        likes = [String]()
        comments = [Comment]()
        
        let date = json["lastUpdate"] as! Double?
        if(date != nil) {
            timestamp = date!
            lastUpdate = Consts.General.convertTimestampToStringDate(self.timestamp)
        }
        else {
            timestamp = 0
            lastUpdate = ""
        }
        
        //setting likes
        if json.keys.contains("likes") {
            let jsonUsersLikes = json["likes"] as? [String:Any]
            if jsonUsersLikes != nil {
                jsonToLikes(jsonUsersLikes!)
            }
        }
        
        //setting comments
        if json.keys.contains("comments") {
            let jsonComments = json["comments"] as? [String:Any]
            if jsonComments != nil {
                jsonToComments(jsonComments!)
            }
        }
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["userID"] = userID
        json["location"] = location
        json["description"] = description
        json["imageUrl"] = imageUrl ?? ""
        json["lastUpdate"] = ServerValue.timestamp()
        json["likes"] = likesToJson()
        json["comments"] = commentsToJson()
        
        return json
    }
    
    private func likesToJson() -> [String:Any] {
        var array:[String:Any] = [String:Any]()
        
        for userId in likes {
            array[userId] = ""
        }
        
        return array
    }
    
    private func jsonToLikes(_ jsonUsersLikes:[String:Any]) {
        for userId in jsonUsersLikes {
            likes.append(userId.key as String)
        }
    }
    
    private func commentsToJson() -> [String:Any] {
        var array:[String:Any] = [String:Any]()
        for comment in comments {
            if comment.id != nil {
                array[comment.id!] = comment.toJson()
            }
        }
        
        return array
    }
    
    private func jsonToComments(_ jsonComments:[String:Any]) {
        for comment in jsonComments {
            comments.append(Comment(comment.key, comment.value as! [String:Any]))
        }
    }
    
    class Comment {
        var id:String? = nil
        var userId:String = ""
        var comment:String = ""
        var lastUpdate:String = ""
        var timestamp:Double = 0
        
        init(_ userId:String, _ comment:String) {
            self.userId = userId
            self.comment = comment
        }
        
        init(_ id:String, _ commentDetails:[String:Any]) {
            self.id = id
            self.userId = commentDetails["userID"] as! String
            self.comment = commentDetails["comment"] as! String
            
            let date = commentDetails["lastUpdate"] as! Double?
            if(date != nil) {
                timestamp = date!
                lastUpdate = Consts.General.convertTimestampToStringDate(self.timestamp)
            }
            else {
                timestamp = 0
                lastUpdate = ""
            }
        }
        
        func toJson() -> [String:Any] {
            var comment:[String:Any] = [String:Any]()
            
            comment["userID"] = self.userId
            comment["comment"] = self.comment
            comment["lastUpdate"] = ServerValue.timestamp()
            
            return comment
        }
    }
}



