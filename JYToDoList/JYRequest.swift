//
//  JYRequest.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

class JYRequest {
    
    func addTodo(input: JYRequestData, callback: (output: JYResponse) -> Void) {
        
        JYRESTful().request(.POST, url: Constants.ADD_TASK, data: input.wrapValue) { (status, data) in
            callback(output: JYResponse(status: status, data: data))
        }
    }
    
    func updateTodoWithId(id: String, input: JYRequestData, callback: (output: JYResponse) -> Void) {
        
        JYRESTful().request(.PUT, url: Constants.UPDATE_FINISHED + id, data: input.wrapValue) { (status, data) in
            callback(output: JYResponse(status: status, data: data))
        }
    }
    
    func deleteTodo(id: String, callback: (output: JYResponse) -> Void) {
        
        JYRESTful().request(.DELETE, url: Constants.DELETE_TASK + id) { (status, data) in
            callback(output: JYResponse(status: status, data: data))
        }
    }
    
    func syncTodoList(input: AddMutipleTaskRequestData, callback: (output: JYResponse) -> Void) {
        
        JYRESTful().request(.POST, url: Constants.ADD_TASK, data: input.wrapValue) { (status, data) in
            callback(output: JYResponse(status: status, data: data))
        }
    }
}
