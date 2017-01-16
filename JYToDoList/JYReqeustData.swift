//
//  JYReqeustData.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

protocol JYRequestData {
    var wrapValue: Dictionary<String, AnyObject> { get }
}

struct AddTaskRequestData: JYRequestData {
    
    var wrapValue: Dictionary<String, AnyObject>
    
    init(todo: ToDo) {
        
        self.wrapValue = ["datetime": todo.date, "task": todo.task, "isFinish": todo.isFinish, "id": todo.id]
    }
}

struct AddMutipleTaskRequestData: JYRequestData {
    
    var wrapValue: Dictionary<String, AnyObject>
    
    init(todoList: Array<ToDo>) {
        
        var wrapTodos: Array<Dictionary<String, AnyObject>> = []
        for todo in todoList {
            wrapTodos.append(AddTaskRequestData(todo: todo).wrapValue)
        }
        
        self.wrapValue = ["rows": wrapTodos]
    }
}