//
//  JYDBManager.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation
import FMDB

class JYDBManager {
    
    let dbVersion: UInt32 = 1
    static let sharedDB = JYDBManager()
    let queue: FMDatabaseQueue
    
    private init () {

        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "/JYDB.db"
        self.queue = FMDatabaseQueue(path: path)
        self.createDB()
    }
    
    private func createDB() {

        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("CREATE TABLE IF NOT EXISTS \(Constants.Table.TO_DO_LIST) (\(Constants.Column.DATE) TEXT, \(Constants.Column.TASK) TEXT, \(Constants.Column.IS_FINISH) INTEGER, \(Constants.Column.IS_SYNC) INTEGER)", values: nil)
                db.setUserVersion(self.dbVersion)
            }
            catch {
                print(error)
            }
        }
    }
    
    func insertTask(todo: ToDo) -> (errorReason: String, id: String) {
        
        var errorReason: String = ""
        var id: String = ""
        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("INSERT INTO \(Constants.Table.TO_DO_LIST) VALUES(?,?,?,?)", values: [todo.date, todo.task, todo.isFinish, false])
                id = "\(db.lastInsertRowId())"
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return (errorReason: errorReason, id: id)
    }
    
    func updateIsFinished(id: String) -> String {
        
        var errorReason: String = ""
        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("UPDATE \(Constants.Table.TO_DO_LIST) SET \(Constants.Column.IS_FINISH) = 1 AND \(Constants.Column.IS_SYNC) = 0 WHERE rowid = ?", values: [id])
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return errorReason
    }
    
    func deleteTask(id: String) -> String {
    
        var errorReason: String = ""
        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("DELETE FROM \(Constants.Table.TO_DO_LIST) WHERE rowid = ?", values: [id])
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return errorReason
    }
    
    func couldIsSync(ids: Array<String>) -> String {
        
        var errorReason: String = ""
        queue.inDatabase { (db) in
            do {
                for id in ids {
                    try db.executeUpdate("UPDATE \(Constants.Table.TO_DO_LIST) SET \(Constants.Column.IS_SYNC) = 1 WHERE rowid = ?", values: [id])
                }
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return errorReason
    }
    
    func selectNotSync() -> (errorReason: String, unSyncList: Array<ToDo>) {
        
        var errorReason: String = ""
        var unSyncList: Array<ToDo> = []
        queue.inDatabase { (db) in
            do {
                let rs = try db.executeQuery("SELECT *, rowid FROM \(Constants.Table.TO_DO_LIST) WHERE \(Constants.Column.IS_SYNC) = 0", values: [])
                while rs.next() {
                    
                    let id = rs.stringForColumn("rowid")
                    let date = rs.stringForColumn(Constants.Column.DATE)
                    let task = rs.stringForColumn(Constants.Column.TASK)
                    let isFinsh = rs.boolForColumn(Constants.Column.IS_FINISH)
                    unSyncList.append(ToDo(id: id, date: date, task: task, isFinish: isFinsh))
                }
                rs.close()
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return (errorReason: errorReason, unSyncList: unSyncList)
    }
    
    func selectToDoList() -> (errorReason: String, todolist: Array<ToDo>) {
        
        var errorReason: String = ""
        var todolist: Array<ToDo> = []
        queue.inDatabase { (db) in
            do {
                let rs = try db.executeQuery("SELECT *, rowid FROM \(Constants.Table.TO_DO_LIST)", values: [])
                while rs.next() {
                    
                    let id = rs.stringForColumn("rowid")
                    let date = rs.stringForColumn(Constants.Column.DATE)
                    let task = rs.stringForColumn(Constants.Column.TASK)
                    let isFinsh = rs.boolForColumn(Constants.Column.IS_FINISH)
                    todolist.append(ToDo(id: id, date: date, task: task, isFinish: isFinsh))
                }
                rs.close()
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return (errorReason: errorReason, todolist: todolist)
    }
    
    func deleteTables() {
        
        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("DELETE FROM \(Constants.Table.TO_DO_LIST)", values: nil)
            }
            catch {
                print(error)
            }
        }
    }
    
    func updateTask(task: String, id: String) -> String {
        
        var errorReason: String = ""
        queue.inDatabase { (db) in
            do {
                try db.executeUpdate("UPDATE \(Constants.Table.TO_DO_LIST) SET \(Constants.Column.TASK) = ? AND \(Constants.Column.IS_SYNC) = 0 WHERE rowid = ?", values: [task, id])
            }
            catch {
                errorReason = db.lastErrorMessage()
            }
        }
        return errorReason
    }
}
