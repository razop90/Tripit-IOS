//
//  Post.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var id:String
    let userID:String
    let location:String
    let description:String
    var creationDate:String
    var imageUrl:String?
    var likes:Int
    
    init(_userID:String, _id:String, _location:String, _description:String, _imageUrl:String? = nil){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = _imageUrl
        likes = 0
        creationDate = ""
        creationDate = getNowDate()
    }
    
    init(_userID:String, _id:String, _location:String, _description:String){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = nil
        likes = 0
        creationDate = ""
        creationDate = getNowDate()
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        userID = json["userID"] as! String
        location = json["location"] as! String
        description = json["description"] as! String
        imageUrl = json["imageUrl"] as? String
        likes = json["likes"] as! Int
        creationDate = json["creationData"] as! String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["userID"] = userID
        json["location"] = location
        json["description"] = description
        json["imageUrl"] = imageUrl ?? ""
        json["likes"] = likes
        json["creationData"] = creationDate

        return json
    }
    
     private func getNowDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyy/MM/dd HH:mm:ss"
        let now = df.string(from: Date())
        
        return now
    }
}



