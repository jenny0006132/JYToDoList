//
//  Constants.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

struct Constants {

    static let SEVER_URL = "https://sheetsu.com/apis/v1.0/"
    static let ADD_TASK = SEVER_URL + "33c5388b14a9"
    static let UPDATE_FINISHED = SEVER_URL + "6052d6d4e7d1/id/"
    static let DELETE_TASK = SEVER_URL + "7b9bcce3c6ff/id/"
    
    struct Table {
        static let TO_DO_LIST = "todolist"
    }
    
    struct Column {
        static let DATE = "date"
        static let TASK = "task"
        static let IS_FINISH = "isFinish"
        static let IS_SYNC = "isSync"
        static let DELETED = "deleted"
    }
    
    struct Image {
        static let CHECK = "check"
        static let UNCHECK = "uncheck"
        static let ADD = "add"
    }
}
