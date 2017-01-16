//
//  PopupView.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit

class PopupView: UIView {
    
    let messageView = UIView()
    let screenSize = UIScreen.mainScreen().bounds
    
    init(scale: CGFloat) {
        
        super.init(frame: screenSize)
        
        messageView.frame = CGRectMake(0, 0, screenSize.width * scale, screenSize.height * scale)
        setup()
    }
    
    init(size: CGSize) {
        
        super.init(frame: screenSize)
        
        messageView.frame = CGRectMake(0, 0, size.width, size.height)
        setup()
    }
    
    func setup() {
        
        hidden = true
        frame = screenSize
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        UIApplication.sharedApplication().keyWindow!.addSubview(self)
        
        messageView.center = CGPointMake(self.center.x, screenSize.height * 3 / 2)
        messageView.backgroundColor = UIColor.whiteColor()
        messageView.layer.cornerRadius = 6.0
        messageView.layer.masksToBounds = true
        addSubview(messageView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popdown)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func popup() {
        
        self.hidden = false
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.messageView.center = self.center
            }, completion: nil)
    }
    
    func popdown() {
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.messageView.center = CGPointMake(self.center.x, self.screenSize.height * 3 / 2)
        }) {(complete) in
            
            self.hidden = true
            self.removeFromSuperview()
        }
    }
}
