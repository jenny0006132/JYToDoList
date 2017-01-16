//
//  Theme.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func themeColor() -> UIColor {
        return UIColor(red: 195/225, green: 26/225, blue: 37/225, alpha: 1)
    }
}

extension UIImageView {
    
    func setImageWithColor(image: UIImage?, color: UIColor) {
        
        self.tintColor = color
        self.image = image?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    func resetImageColor(color: UIColor) {
        
        self.tintColor = color
        self.image = self.image?.imageWithRenderingMode(.AlwaysTemplate)
    }
}