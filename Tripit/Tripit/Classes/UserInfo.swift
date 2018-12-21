//
//  UserInfo.swift
//  Tripit
//
//  Created by admin on 21/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation

class UserInfo {
    let uid:String
    let displayName:String
    let email:String
    var profileImageUrl:String?
    
    init(_uid:String, _displayName:String, _email:String, _profileImageUrl:String? = nil) {
        uid = _uid
        displayName = _displayName
        email = _email
        profileImageUrl = _profileImageUrl
    }
 
    init(_uid:String, json:[String:Any]) {
        uid = _uid
        displayName = json["displayName"] as! String
        email = json["email"] as! String
        profileImageUrl = json["profileImageUrl"] as? String
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        
        json["displayName"] = displayName
        json["email"] = email
        json["profileImageUrl"] = profileImageUrl ?? ""
        
        return json
    }
}

