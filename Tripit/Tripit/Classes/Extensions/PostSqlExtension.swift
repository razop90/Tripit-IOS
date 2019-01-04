//
//  PostSqlExtension.swift
//  Tripit
//
//  Created by admin on 28/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import SQLite3

extension Post {
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (ID TEXT PRIMARY KEY, USERID TEXT, LOCATION TEXT, DESCRIPTION TEXT, IMAGEURL TEXT, CREATION_DATE DOUBLE, LAST_UPDATE DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE POSTS;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?, userId:String? = nil)->[Post] {
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        var query = "SELECT * from POSTS;"
        if(userId != nil) {
            query = "SELECT * from POSTS where USERID = '" + userId! + "' ;"
        }
        
        if (sqlite3_prepare_v2(database,query,-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let ID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let userID = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let location = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let description = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let imageUrl = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                let creationDate:Double = sqlite3_column_double(sqlite3_stmt,5)
                let lastUpdate:Double = sqlite3_column_double(sqlite3_stmt,6)
                
                let post = Post(_userID: userID, _id: ID, _location: location, _description: description, _creationDate: creationDate, _imageUrl: imageUrl, _lastUpdate: lastUpdate)
                
                let comments = Post.Comment.getAll(database: database, postID: post.id)
                post.comments = comments
                
                let likes = Post.getLikes(database: database, postId: post.id)
                post.likes = likes
                
                data.append(post)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, post:Post) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(ID, USERID, LOCATION, DESCRIPTION, IMAGEURL,CREATION_DATE, LAST_UPDATE) VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = post.id.cString(using: .utf8)
            let userID = post.userID.cString(using: .utf8)
            let location = post.location.cString(using: .utf8)
            let description = post.description.cString(using: .utf8)
            let imageUrl = post.imageUrl?.cString(using: .utf8)
            let creationDate = post.creationDate
            let lastUpdate = post.lastUpdate
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, location,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, imageUrl,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 6, creationDate);
            sqlite3_bind_double(sqlite3_stmt, 7, lastUpdate);
            
            //saving post's comments
            for comment in post.comments {
                Post.Comment.addNew(database: database, postID: post.id, comment: comment)
            }
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "POSTS")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tableName: "POSTS", date: date);
    }
}
