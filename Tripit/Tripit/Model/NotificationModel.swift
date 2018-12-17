//
//  NotificationModel.swift
//  Tripit
//
//  Created by admin on 14/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation

class NotificationModel{
    static let postsListNotification = Notification<[Post]>("notification.postsdata")
    static let postsCommentstNotification = Notification<[Post.Comment]>("notification.postcommentsdata")

    class Notification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
    }
}
