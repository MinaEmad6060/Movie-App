//
//  DataBaseManager.swift
//  Movies
//
//  Created by Mina Emad on 01/05/2024.
//

import Foundation

import Foundation
import SQLite3


class DataBaseManager{
    static let dataBase = DataBaseManager()
    
    private let dbPathString: String
    private var db: OpaquePointer?
    
    let insertTableString = """
    INSERT INTO Movies (title,image,genre,rating,releaseDate) VALUES (?,?,?,?,?);
"""
    let queryTableString = "select * from Movies;"
    
    let deleteTableString = "delete from Movies where title = ?;"
    
    private init(){
        let fileManager = FileManager.default
        guard let fileUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
            fatalError("Codn't access documents directory.")
        }
        
        self.dbPathString = fileUrl.appendingPathComponent("MoviesTest1.sqlite").path
        if sqlite3_open(dbPathString, &db) == SQLITE_OK{
            print("Success")
        }else{
            print("Unable to open database")
        }
        
        
        let createTableString = """
        create table Movies(
        id integer primary key autoincrement not null,
        title char(255) not null,
        image char(255),
        genre char(255),
        rating double,
        releaseDate integer)
    """
  
        var createTableStatement: OpaquePointer?
        if (sqlite3_prepare(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK){
            print("table statement prepared")
            if sqlite3_step(createTableStatement) == SQLITE_OK{
                print("table created\n")
            }else{
                print("table not created\n")
            }
        }else{
            print("table statement not prepared\n")
        }
        
        sqlite3_finalize(createTableStatement)
    }
 
    func insert(title: String, image: Data, genre: String, rating: Double, releaseDate: Int){
        var insertStatement: OpaquePointer?
        
        if (sqlite3_prepare(db, insertTableString, -1, &insertStatement, nil) == SQLITE_OK){
            let title: NSString = NSString(string: title)
            let genre: NSString = NSString(string: genre)
            let rating: Double = rating
            let releaseDate: Int = releaseDate
            
            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
            sqlite3_bind_blob(insertStatement, 2, (image as NSData).bytes, Int32(image.count), nil)
            sqlite3_bind_text(insertStatement, 3, genre.utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 4, rating)
            sqlite3_bind_int(insertStatement, 5, Int32(releaseDate))

            print("insert statement prepared\n")
            if sqlite3_step(insertStatement) == SQLITE_OK{
                print("insert created\n")
            }else{
                print("insert not created\n")
            }
        }else{
            print("insert statement not prepared\n")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func query()-> [Movie]{
        var queryStatement: OpaquePointer?
        var movieList: [Movie] = []
        
        if sqlite3_prepare(db, queryTableString, -1, &queryStatement, nil) == SQLITE_OK {
                print("query prepared\n")
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    guard let imageDataBlob = sqlite3_column_blob(queryStatement, 2) else {
                                        continue
                                    }
                    let imageDataBytes = sqlite3_column_bytes(queryStatement, 2)
                    let imageData = Data(bytes: imageDataBlob, count: Int(imageDataBytes))
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1),
                          let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                          else {
                        print("Query col 1 result is null\n")
                        continue
                    }
                    let title = String(cString: queryResultCol1)
                    let genre = String(cString: queryResultCol3)
                    let rating = sqlite3_column_double(queryStatement, 4)
                    let year = sqlite3_column_int(queryStatement, 5)
                    print("Query result: \n")
                    print("\(title)\n")
                    let movie = Movie(title: title, image: imageData, releaseYear: Int(year), genre: genre, rating: rating)
                    movieList.append(movie)
                }
            } else {
                print("query not prepared\n")
            }
                
        
        sqlite3_finalize(queryStatement)
        
        return movieList
    }
    
    
    func delete(title: String){
        var deleteStatement: OpaquePointer?
        
        if (sqlite3_prepare(db, deleteTableString, -1, &deleteStatement, nil) == SQLITE_OK){
            print("delete statement prepared\n")
            sqlite3_bind_text(deleteStatement, 1, NSString(string: title).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_OK{
                print("delete created\n")
            }else{
                print("delete not created\n")
            }
        }else{
            print("delete not prepared\n")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    deinit{
        print("DEiniT not prepared\n")
        sqlite3_close(db)
    }
}

