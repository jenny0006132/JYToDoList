//
//  JYResponseData.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation
import SwiftyJSON

class JYResponse {
    
    private var data: JSON?
    var status: HTTPStatusCode! {
        didSet {
            errorReason = status.reason()
            success = status.isSuccess()
        }
    }
    
    var errorReason: String = ""
    var success: Bool = false
    
    init(status: HTTPStatusCode, data: JSON?) {
        
        self.data = data
        ({ self.status = status })()
    }
}

extension JYResponse {
    
    func getToDoList() -> Array<ToDo> {
        
        guard let data = data else {
            return []
        }
        
        var list: Array<ToDo> = []
        for task in data.arrayValue {
            list.append(ToDo(id: task["id"].stringValue, date: task["dateTime"].stringValue, task: task["task"].stringValue, isFinish: task["isFinish"].boolValue))
        }
        return list
    }
}
