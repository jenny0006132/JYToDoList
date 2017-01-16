//
//  JYListManager.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit
import Foundation

class JYListManager {
    
    func getToDoList() -> ToDoListResponse {
        
        let (errorReason, todoList) = JYDBManager.sharedDB.selectToDoList()
        return ToDoListResponse(success: errorReason.isEmpty, errorReason: errorReason, todolist: todoList)
    }
    
    func addTodo(todo: ToDo, callback: (syncResponse: SimpleResponse) -> Void) -> ToDoResponse {
        
        var todo = todo
        let (errorReason, id) = JYDBManager.sharedDB.insertTask(todo)
        todo.id = id
        
        JYRequest().addTodo(AddTaskRequestData(todo: todo)) { (output) in
            
            JYDBManager.sharedDB.couldIsSync([id])
            callback(syncResponse: SimpleResponse(success: output.success, errorReason: output.errorReason))
        }

        return ToDoResponse(success: errorReason.isEmpty, errorReason: errorReason, todo: todo)
    }
    
    func updateIsFinish(todo: ToDo, callback: (syncResponse: SimpleResponse) -> Void) -> SimpleResponse {
        
        let errorReason = JYDBManager.sharedDB.updateIsFinished(todo.id)
        
        JYRequest().updateTodoWithId(todo.id, input: AddTaskRequestData(todo: todo)) { (output) in
            JYDBManager.sharedDB.couldIsSync([todo.id])
            callback(syncResponse: SimpleResponse(success: output.success, errorReason: output.errorReason))
        }
        return SimpleResponse(success: errorReason.isEmpty, errorReason: errorReason)
    }
    
    func deleteTodo(id: String, callback: (syncResponse: SimpleResponse) -> Void) -> SimpleResponse {
        
        let errorReason = JYDBManager.sharedDB.deleteTask(id)

        JYRequest().deleteTodo(id) { (output) in
            callback(syncResponse: SimpleResponse(success: output.success, errorReason: output.errorReason))
        }
        return SimpleResponse(success: errorReason.isEmpty, errorReason: errorReason)
    }
    
    func syncNotUpload(callback: (syncResponse: SimpleResponse) -> Void) -> SyncResponse {
        
        let (errorReason, todoList) = JYDBManager.sharedDB.selectNotSync()
    
        if !todoList.isEmpty {
        
            JYRequest().syncTodoList(AddMutipleTaskRequestData(todoList: todoList)) { (output) in
                
                JYDBManager.sharedDB.couldIsSync(self.getToDoIdsWithToDos(todoList))
                callback(syncResponse: SimpleResponse(success: output.success, errorReason: output.errorReason))
            }
        }
        return SyncResponse(success: errorReason.isEmpty, errorReason: errorReason, sync: !todoList.isEmpty)
    }
    
    func getToDoIdsWithToDos(todoList: Array<ToDo>) -> Array<String> {
        
        var idList: Array<String> = []
        for todo in todoList {
            idList.append(todo.id)
        }
        return idList
    }
    
    func updateTodo(todo: ToDo, callback: (syncResponse: SimpleResponse) -> Void) -> SimpleResponse {
        
        let errorReason = JYDBManager.sharedDB.updateTask(todo.task, id: todo.id)
        
        JYRequest().updateTodoWithId(todo.id, input: AddTaskRequestData(todo: todo)) { (output) in
            JYDBManager.sharedDB.couldIsSync([todo.id])
            callback(syncResponse: SimpleResponse(success: output.success, errorReason: output.errorReason))
        }
        return SimpleResponse(success: errorReason.isEmpty, errorReason: errorReason)
    }
}
