//
//  SqlModel.swift
//  Tripit
//
//  Created by admin on 28/12/2018.
//  Copyright © 2018 razop. All rights reserved.
//

import Foundation
import SQLite3

class SqlModel {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            //dropTables()
            createTables()
        }
    }
    
    func createTables() {
        Post.createTable(database: database);
        Post.Comment.createTable(database: database);
        UserInfo.createTable(database: database);
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables() {
        Post.drop(database: database)
        Post.Comment.drop(database: database)
        UserInfo.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
}




