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
    var location:String
    var description:String
    var creationDateStringFormat:String
    var creationDate:Double
    var lastUpdate:Double
    var imageUrl:String?
    var likes:[String] //contains user id's
    var isDeleted:Int //0 for false, 1 for true
    var comments:[Comment]
    
    init(_userID:String, _id:String, _location:String, _description:String, _creationDate:Double = 0, _imageUrl:String? = nil, _lastUpdate:Double = 0){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = _imageUrl
        likes = [String]()
        comments = [Comment]()
        creationDate = _creationDate
        creationDateStringFormat = Consts.General.convertTimestampToStringDate(self.creationDate)
        lastUpdate = _lastUpdate
        isDeleted = 0
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        userID = json["userID"] as! String
        location = json["location"] as! String
        description = json["description"] as! String
        imageUrl = json["imageUrl"] as? String
        isDeleted = json["isDeleted"] as? Int ?? 0
        likes = [String]()
        comments = [Comment]()
        
        let _creationDate = json["creationDate"] as! Double?
        if(_creationDate != nil) {
            creationDate = _creationDate!
            creationDateStringFormat = Consts.General.convertTimestampToStringDate(self.creationDate)
        }
        else {
            creationDate = 0
            creationDateStringFormat = ""
        }
        
        let _lastUpdate = json["lastUpdate"] as! Double?
        if(_lastUpdate != nil) {
            lastUpdate = _lastUpdate!
        }
        else {
            lastUpdate = 0
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
        json["isDeleted"] = isDeleted
        json["imageUrl"] = imageUrl ?? ""
        json["creationDate"] = ServerValue.timestamp()
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
        
        init(_ userId:String, _ comment:String, _ timestamp:Double = 0, _ id:String? = nil) {
            self.id = id
            self.userId = userId
            self.comment = comment
            self.timestamp = timestamp
            self.lastUpdate = Consts.General.convertTimestampToStringDate(self.timestamp)
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



