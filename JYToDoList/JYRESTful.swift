//
//  JYRESTful.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ReachabilitySwift

enum JYMethod {
    case GET
    case POST
    case PUT
    case DELETE
    
    func getAlamofireMethod() -> Alamofire.Method {
        
        switch self {
        case GET:
            return Alamofire.Method.GET
        case POST:
            return Alamofire.Method.POST
        case PUT:
            return Alamofire.Method.PUT
        case DELETE:
            return Alamofire.Method.DELETE
        }
    }
}

class JYRESTful {
    
    func request(method: JYMethod, url: String, data: Dictionary<String, AnyObject>? = nil, handler: (status: HTTPStatusCode, data: JSON?) -> Void ) {
        
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            
            if reachability.isReachable() {
                
                Alamofire.request(method.getAlamofireMethod(), url, parameters: data).responseJSON { response in
                    
                    print("\(method.getAlamofireMethod().rawValue): \(data)")
                    guard let statusCode = response.response?.statusCode, httpStatusCode = HTTPStatusCode(rawValue: statusCode), json = response.result.value else {
                        handler(status: HTTPStatusCode.Unknow, data: nil)
                        return
                    }
                    handler(status: httpStatusCode, data: JSON(json))
                }
            }
            
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
}
