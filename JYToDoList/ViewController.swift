//
//  ViewController.swift
//  JYToDoList
//
//  Created by Jenny Yao on 2017/1/15.
//  Copyright © 2017年 Jenny Yao. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var popupView: AddTaskPopupView?
    var todoList: Array<ToDo> = []
    
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setReachablilityObserver()
        getToDoList()
        syncCloudDataIfNeeded()
    }
    
    func setupView() {
     
        setTitleDefualt()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.Image.ADD), style: .Plain, target: self, action: #selector(addTask))
    }
    
    func addTask() {
        
        popupView = AddTaskPopupView()
        popupView?.delegate = self
        popupView?.popup()
    }
    
    func getToDoList() {
        
        let dbResponse = JYListManager().getToDoList()
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        self.todoList = dbResponse.todolist
        self.tableView.reloadData()
    }
    
    func syncCloudDataIfNeeded() {
        
        let dbResponse = JYListManager().syncNotUpload { (syncResponse) in
            
            guard syncResponse.success else {
                self.showAlert(syncResponse.errorReason)
                return
            }
            self.setTitleDefualt()
        }
        
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        if dbResponse.sync {
            setTitleUpdateCloud()
        }
    }

    func showAlert(title: String) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func setTitleDefualt() {
        title = "JYToDoList"
    }
    
    func setTitleUpdateCloud() {
        
        if isConnected() {
            title = "Update to Cloud..."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! JYToDoListTableViewCell
        cell.todo = todoList[indexPath.row]
        cell.checkButton.addTarget(self, action: #selector(checked), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func checked(sender: UIButton) {
        
        if let indexPath = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView)) {
            updateIsFinish(indexPath)
        }
    }
    
    func updateIsFinish(indexPath: NSIndexPath) {
        
        todoList[indexPath.row].isFinish = true
        
        let dbResponse = JYListManager().updateIsFinish(todoList[indexPath.row]) { (syncResponse) in
            
            guard syncResponse.success else {
                self.showAlert(syncResponse.errorReason)
                return
            }
            self.setTitleDefualt()
        }
        
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        setTitleUpdateCloud()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.deleteTask(self.todoList[indexPath.row].id, row: indexPath.row)
        })
        
        let editeRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Update", handler:{action, indexpath in
            self.updateTask(indexPath.row)
        })
        
        deleteRowAction.backgroundColor = UIColor.redColor()
        editeRowAction.backgroundColor = UIColor.lightGrayColor()
        
        return [deleteRowAction, editeRowAction];
    }
    
    func deleteTask(id: String, row: Int) {
        
        let dbResponse = JYListManager().deleteTodo(id) { (syncResponse) in
            
            guard syncResponse.success else {
                self.showAlert(syncResponse.errorReason)
                return
            }
            self.setTitleDefualt()
        }
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        todoList.removeAtIndex(row)
        tableView.reloadData()
        setTitleUpdateCloud()
    }
    
    func updateTask(row: Int) {
        
        popupView = AddTaskPopupView(task: todoList[row].task)
        popupView?.delegate = self
        popupView?.dataTag = row
        popupView?.popup()
    }
}

extension ViewController: AddTaskPopupViewDelegate {

    func doneClickWithTask(popupView: AddTaskPopupView, task: String) {

        let todo = ToDo(date: getCurrentTimeString(), task: task, isFinish: false)
        
        let dbResponse = JYListManager().addTodo(todo) { (syncResponse) in
            
            guard syncResponse.success else {
                self.showAlert(syncResponse.errorReason)
                return
            }
            self.setTitleDefualt()
        }
        
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        todoList.append(dbResponse.todo)
        tableView.reloadData()
        setTitleUpdateCloud()
    }
    
    func updateClickWithTask(popupView: AddTaskPopupView, task: String) {
        
        todoList[popupView.dataTag].task = task
        
        let dbResponse = JYListManager().updateTodo(todoList[popupView.dataTag]) { (syncResponse) in
            
            guard syncResponse.success else {
                self.showAlert(syncResponse.errorReason)
                return
            }
            self.setTitleDefualt()
        }
        
        guard dbResponse.success else {
            self.showAlert(dbResponse.errorReason)
            return
        }
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: popupView.dataTag, inSection: 0)], withRowAnimation: .None)
        setTitleUpdateCloud()
    }
}

extension ViewController {

    func setReachablilityObserver() {
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability?.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                self.syncCloudDataIfNeeded()
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                self.setTitleDefualt()
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func isConnected() -> Bool {
        
        return reachability?.isReachable() ?? false
    }
}
