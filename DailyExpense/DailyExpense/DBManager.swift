//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class DBManager: NSObject {

    let field_ExpenseID = "expenseID"
    let field_ExpenseTitle = "title"
    let field_ExpenseCategory = "categories"
    let field_ExpenseAmount = "amount"
    let field_ExpenseDate = "date"
    let field_Notes = "notes"
   
    
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createMoviesTableQuery = "create table expense (\(field_ExpenseID) integer primary key autoincrement not null, \(field_ExpenseTitle) text not null,\(field_ExpenseAmount) text not null,\(field_ExpenseDate) text,\(field_ExpenseCategory) text not null, \(field_Notes) text)"
                    
                    
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    
 
    
    func loadExpense() -> [ExpenseModel]! {
        var expenses: [ExpenseModel]!
        
        if openDatabase() {
            let query = "select * from expense order by \(field_ExpenseDate) asc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let expense = ExpenseModel(expenseID: Int(results.int(forColumn: field_ExpenseID)), title: results.string(forColumn: field_ExpenseTitle), amount: results.string(forColumn: field_ExpenseAmount), date: results.string(forColumn: field_ExpenseDate), categories: results.string(forColumn: field_ExpenseCategory), notes: results.string(forColumn: field_Notes))
                    
                    
                    if expenses == nil {
                        expenses = [ExpenseModel]()
                    }
                    
                    expenses.append(expense)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return expenses
    }
    
    func insertExpense(titleStr:String,amt:String,dat:String,categories:String,notes:String = "") -> String
    {
        let contactDB = pathToDatabase as String
        
        if (openDatabase()) {
            
            let insertSQL = "INSERT INTO expense (title, amount, date,categories,notes) VALUES ('\(titleStr)', '\(amt)', '\(dat)','\(categories)','\(notes)')"
            
            let result = database.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            
            if !result {
                return database.lastErrorMessage()
            } else {
                return "Expense Added"
            }
            database.close()
        } else {
            return database.lastErrorMessage()
        }
        
    }
    
    
 
}
