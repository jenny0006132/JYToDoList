//
//  AddTaskPopupView.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit

protocol AddTaskPopupViewDelegate: class {
    
    func doneClickWithTask(popupView: AddTaskPopupView, task: String)
    func updateClickWithTask(popupView: AddTaskPopupView, task: String)
}

class AddTaskPopupView: PopupView {
    
    var done: UIButton!
    var taskTextField: UITextField!
    weak var delegate: AddTaskPopupViewDelegate? = nil
    var isUpdate: Bool = false
    
    init() {
        
        let edge: CGFloat = 16.0
        let itemHeight: CGFloat = 30.0
        let width = UIScreen.mainScreen().bounds.width - edge
        
        super.init(size: CGSizeMake(width, itemHeight*2 + 3*edge))
        
        taskTextField = UITextField(frame: CGRectMake(edge, edge, messageView.frame.width - 2 * edge, itemHeight))
        taskTextField.placeholder = "Please Enter you task..."
        taskTextField.becomeFirstResponder()
        messageView.addSubview(taskTextField)
        
        done = UIButton(frame: CGRectMake(0, 0, width/2, itemHeight))
        done.center = CGPointMake(taskTextField.center.x, taskTextField.frame.origin.y + taskTextField.frame.height + done.frame.height/2 + edge)
        done.backgroundColor = UIColor.themeColor()
        done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        done.setTitle("done", forState: .Normal)
        done.addTarget(self, action: #selector(doneClick), forControlEvents: .TouchUpInside)
        messageView.addSubview(done)
    }
    
    convenience init(task: String) {

        self.init()
        taskTextField.text = task
        isUpdate = true
        done.setTitle("update", forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func popup() {
        
        self.hidden = false
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.messageView.center = CGPoint(x: self.center.x, y: self.center.y - UIScreen.mainScreen().bounds.height/3)
            }, completion: nil)
    }
    
    func dissmissKeyboard() {
        
        endEditing(true)
    }
    
    func doneClick() {
        
        dissmissKeyboard()
        
        guard let task = taskTextField.text where !task.isEmpty else {
            return
        }
        
        popdown()
        
        if isUpdate {
            delegate?.updateClickWithTask(self, task: task)
        }
        else {
            delegate?.doneClickWithTask(self, task: task)
        }
    }
}

var AssociatedObjectHandle: UInt8 = 0

extension AddTaskPopupView {
    
    var dataTag: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
