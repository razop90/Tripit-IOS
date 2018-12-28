//
//  CommentSqlExtension.swift
//  Tripit
//
//  Created by admin on 28/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import SQLite3

extension Post.Comment {
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS COMMENTS (ID TEXT PRIMARY KEY, POSTID TEXT, USERID TEXT, COMMENT TEXT, TIMESTAMP DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE COMMENTS;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?, postID:String)->[Post.Comment]{
        var sqlite3_stmt: OpaquePointer? = nil
        let query = "SELECT ID, POSTID, USERID, COMMENT, TIMESTAMP from COMMENTS where POSTID = '" + postID + "' ;"
        var data = [Post.Comment]()
        if (sqlite3_prepare_v2(database,query,-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            //sqlite3_bind_text(sqlite3_stmt, 1, postID.cString(using: .utf8), -1,nil)
            
            var sq = sqlite3_step(sqlite3_stmt)
            while(sq == SQLITE_ROW) {
                let ID = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let userID = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let comment_txt = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                let timestamp:Double = sqlite3_column_double(sqlite3_stmt,4)
                
                let comment = Post.Comment(userID, comment_txt, timestamp, ID)
                
                data.append(comment)
                sq = sqlite3_step(sqlite3_stmt)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, postID:String, comment:Post.Comment) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO COMMENTS(ID, POSTID, USERID, COMMENT, TIMESTAMP) VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = comment.id!.cString(using: .utf8)
            let post = postID.cString(using: .utf8)
            let userID = comment.userId.cString(using: .utf8)
            let comment_txt = comment.comment.cString(using: .utf8)
            let timestamp = comment.timestamp
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, post,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, userID,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, comment_txt,-1,nil);
            sqlite3_bind_double(sqlite3_stmt, 5, timestamp);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "COMMENTS")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tableName: "COMMENTS", date: date);
    }
}
