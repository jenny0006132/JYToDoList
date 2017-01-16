//
//  Task.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

struct ToDo {
    
    var id: String = ""
    let date: String
    var task: String
    var isFinish: Bool
    
    init (date: String, task: String, isFinish: Bool) {
        
        self.date = date
        self.task = task
        self.isFinish = isFinish
    }
    
    init (id: String, date: String, task: String, isFinish: Bool) {
        
        self.init(date: date, task: task, isFinish: isFinish)
        self.id = id
    }
}
