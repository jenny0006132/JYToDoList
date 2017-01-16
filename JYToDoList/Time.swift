//
//  Time.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

func getCurrentTimeString() -> String {
    
    let format = NSDateFormatter()
    format.dateFormat = "YYY-MM-dd"
    
    let now = NSDate()
    return format.stringFromDate(now)
}