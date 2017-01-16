//
//  HTTPStatusCode.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    
    case Unknow = 0
    case OK = 200
    case Created = 201
    case NoContent = 204
    case BadRequest = 400
    case Unautourized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NoSuchRoute = 404
    case RateLimitRoute = 429
    case SeverError = 500
    
    func reason() -> String {
        
        switch self {
        case .OK, .Created, .NoContent:
            return "Success"
        case BadRequest:
            return "error creating/updating row(s)"
        case Unautourized:
            return "wrong authorization"
        case PaymentRequired:
            return "pro feature is tried to be accessed from free account"
        case Forbidden:
            return "action is forbidden by the user (Spreadsheet/API owner)"
        case NoSuchRoute:
            return "route which doesn't exists is requested"
        case RateLimitRoute:
            return " you have more hits than your quota"
        case SeverError:
            return "Server error"
        default:
            return "Unknown"
        }
    }
    
    func isSuccess() -> Bool {
        
        switch self {
        case .OK, .Created, .NoContent:
            return true
        default:
            return false
        }
    }
}