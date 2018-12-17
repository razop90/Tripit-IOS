//
//  Consts.swift
//  Tripit
//
//  Created by Raz Vaknin on 29 Kislev 5779.
//  Copyright © 5779 razop. All rights reserved.
//

import Foundation
import UIKit

struct Consts{
    struct Posts {       
        static let PostsTableName: String = "Posts"
        static let ImagesFolderName: String = "ImagesStorage"
        static let LikesTableName: String = "likes"
        static let CommentsTableName: String = "comments"
    }
    
    struct General {
        static func getNowDateTime(_ format:String = "dd/MM/yyyy HH:mm") -> String {
            let df = DateFormatter()
            df.dateFormat = format
            let now = df.string(from: Date())
            
            return now
        }
        
        static func getCancelAlertController(title:String, messgae:String, buttonText:String = "Dismiss") -> UIAlertController
        {
            let alertController = UIAlertController(title: title, message: messgae, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.cancel, handler: nil))
            
            return alertController
        }
    }
}
