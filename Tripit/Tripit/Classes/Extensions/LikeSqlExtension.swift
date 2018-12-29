//
//  LikeSqlExtension.swift
//  Tripit
//
//  Created by admin on 29/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import SQLite3

extension Post {
    
    static func createLikesTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS LIKES (UID TEXT, POST_ID TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating likes table");
            return
        }
    }
    
    static func dropLikesTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE USER_INFO;", nil, nil, &errormsg);
        if(res != 0){
            print("error droping likes table");
            return
        }
    }
    
    static func getLikes(database: OpaquePointer?, postId:String)-> [String] {
        var sqlite3_stmt: OpaquePointer? = nil
        let query = "SELECT UID from LIKES where POST_ID = '" + postId + "' ;"
        var likes = [String]()
        if (sqlite3_prepare_v2(database,query,-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            
            var sq = sqlite3_step(sqlite3_stmt)
            while(sq == SQLITE_ROW) {
                let uid = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                likes.append(uid)
                
                sq = sqlite3_step(sqlite3_stmt)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return likes
    }
    
    static func addNewLike(database: OpaquePointer?, postId:String, userId:String) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO LIKES(UID, POST_ID) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let post = postId.cString(using: .utf8)
            let user = userId.cString(using: .utf8)
          
            sqlite3_bind_text(sqlite3_stmt, 1, user,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, post,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new like added succefully")
            }
        }
    }
    
    static func removeLike(database: OpaquePointer?, postId:String, userId:String) {
        var sqlite3_stmt: OpaquePointer? = nil
        
        let query = "DELETE from LIKES where POST_ID = '" + postId + "' and UID = '" + userId + "' ;"
        if (sqlite3_prepare_v2(database,query,-1, &sqlite3_stmt,nil) == SQLITE_OK){
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("like was deleted succefully")
            }
        }
    }
    
    static func removeAllLikes(database: OpaquePointer?, postId:String) {
        var sqlite3_stmt: OpaquePointer? = nil
        
        let query = "DELETE FROM LIKES where POST_ID = '" + postId + "' ;"
        if (sqlite3_prepare_v2(database,query,-1, &sqlite3_stmt,nil) == SQLITE_OK){
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("like was deleted succefully")
            }
        }
    }
    
    static func getLikesLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "LIKES")
    }
    
    static func setLikesLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tableName: "LIKES", date: date);
    }
}
