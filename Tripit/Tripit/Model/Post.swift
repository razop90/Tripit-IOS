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
    var image:UIImage?
    var imageUrl:String?
    
    init(_userID:String, _id:String, _location:String, _description:String, _imageUrl:String? = nil){
        id = _id
        userID = _userID
        location = _location
        description = _description
        imageUrl = _imageUrl
        image = nil
        loadImage()
    }
    
    init(_userID:String, _id:String, _location:String, _description:String, _image:UIImage? = nil){
        id = _id
        userID = _userID
        location = _location
        description = _description
        image = _image
        imageUrl = nil
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        userID = json["userID"] as! String
        location = json["location"] as! String
        description = json["description"] as! String
        imageUrl = json["imageUrl"] as? String
        image = nil
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["userID"] = userID
        json["location"] = location
        json["description"] = description
        json["imageUrl"] = imageUrl ?? ""

        return json
    }
    
    private func loadImage(){
        if let imageUrl = self.imageUrl{
            //load here
        }
    }
}




