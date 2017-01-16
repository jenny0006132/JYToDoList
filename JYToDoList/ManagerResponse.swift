//
//  ManagerResponse.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

struct SimpleResponse {
    
    let success: Bool
    let errorReason: String
}

struct SyncResponse {
    
    let success: Bool
    let errorReason: String
    let sync: Bool
}

struct ToDoResponse {
    
    let success: Bool
    let errorReason: String
    let todo: ToDo
}

struct ToDoListResponse {
    
    let success: Bool
    let errorReason: String
    let todolist: Array<ToDo>
}
