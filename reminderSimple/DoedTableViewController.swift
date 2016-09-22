//
//  DoedTableViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/09/05.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import EventKit
import RealmSwift

class DoedTableViewController: UITableViewController {
    
    var eventStore: EKEventStore! = EKEventStore()
    var reminders: [EKReminder]! = [EKReminder]()
    var reminderResults:Results<ReminderModel>?
    let realm = try! Realm()
    
    // Buttonを拡張する.
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // 未実行に戻すボタン.
        let yetButton: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "未実行に戻す") { (action, index) -> Void in
            
            tableView.editing = false
            print("doed")
            try! self.realm.write {
                self.reminderResults![indexPath.row].doflg = false
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        yetButton.backgroundColor = UIColor.blueColor()
        
        // 編集ボタン.
        let editButton: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "編集") { (action, index) -> Void in
            
            tableView.editing = false
            print("archive")
            
            let storyboard: UIStoryboard = self.storyboard!
            let detailViewController = storyboard.instantiateViewControllerWithIdentifier("detail") as! DetailViewController
            detailViewController.id = self.reminderResults![indexPath.row].id
            self.presentViewController(detailViewController, animated: true, completion: nil)
            
        }
        editButton.backgroundColor = UIColor.grayColor()
        
        // Deleteボタン.
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "削除") { (action, index) -> Void in
            
            tableView.editing = false
            print("delete")
            // Delete the row from the data source
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(self.reminderResults![indexPath.row])
            try! realm.commitWrite()
            
            //tabelのセルをアニメーションで消す
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        deleteButton.backgroundColor = UIColor.redColor()
        
        return [yetButton, editButton, deleteButton]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        reminderResults = realm.objects(ReminderModel.self).filter("doflg == true")
        print(reminderResults)
        for reminder in reminderResults! {
            print(reminder.title)
            print(reminder.mydate)
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let val = reminderResults {
            return val.count
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reminderCell")
        
        if let dueDate = reminderResults![indexPath.row].mydate {
            let now = NSDate()
            if dueDate.compare(now) == NSComparisonResult.OrderedAscending {
                cell.textLabel?.textColor = UIColor.redColor()
            }
        }
        
        cell.textLabel?.text = reminderResults![indexPath.row].title
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        cell.detailTextLabel?.text = formatter.stringFromDate(reminderResults![indexPath.row].mydate!)
        
        //cell.accessoryType = .Detail
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(reminderResults![indexPath.row])
            try! realm.commitWrite()
            
            //tabelのセルをアニメーションで消す
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}