//
//  JYToDoListTableViewCell.swift
//  JYToDoList
//
//  Created by alpha003 on 2017/1/16.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit

class JYToDoListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    
    var todo: ToDo {
        get {
            return self.todo
        }
        set {
            
            if newValue.isFinish {
                
                checkButton.setImage(UIImage(named: Constants.Image.CHECK), forState: .Normal)
                checkButton.tintColor = UIColor.lightGrayColor()
                
                let attributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                                  NSStrikethroughColorAttributeName: UIColor.lightGrayColor(),
                                  NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                taskLabel.attributedText = NSAttributedString(string: newValue.task, attributes: attributes)
            }
            else {
             
                checkButton.setImage(UIImage(named: Constants.Image.UNCHECK), forState: .Normal)
                checkButton.tintColor = UIColor.themeColor()
                
                let attributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue,
                                  NSForegroundColorAttributeName: UIColor.blackColor()]
                taskLabel.attributedText = NSAttributedString(string: newValue.task, attributes: attributes)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
