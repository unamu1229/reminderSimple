//
//  TableViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/07/17.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import EventKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var category_id = Int()
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var eventStore: EKEventStore! = EKEventStore()
    var reminders: [EKReminder]! = [EKReminder]()
    var reminderResults:Results<ReminderModel>?
    let realm = try! Realm()
    @IBOutlet weak var pagename: UINavigationItem!
    
    // Buttonを拡張する.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // 実行済みボタン.
        var completeOrTaskButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "実行済み") { (action, index) -> Void in
            
            tableView.isEditing = false
            print("doed")
            try! self.realm.write {
                self.reminderResults![(indexPath as NSIndexPath).row].doflg = true
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        completeOrTaskButton.backgroundColor = UIColor.blue
        
        if appDelegate.fromPage ==  "showComplete" || appDelegate.fromPage ==  "showCompleteCategory" {
            
            // 未実行に戻すボタン.
            completeOrTaskButton = UITableViewRowAction(style: .normal, title: "未実行に戻す") { (action, index) -> Void in
                
                tableView.isEditing = false
                print("doed")
                try! self.realm.write {
                    self.reminderResults![(indexPath as NSIndexPath).row].doflg = false
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completeOrTaskButton.backgroundColor = UIColor.blue
            
        }
        
        // Deleteボタン.
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            tableView.isEditing = false
            print("delete")
            // Delete the row from the data source
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(self.reminderResults![(indexPath as NSIndexPath).row])
            try! realm.commitWrite()
            
            //tabelのセルをアニメーションで消す
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        deleteButton.backgroundColor = UIColor.red
        
        // 編集ボタン.
        let editButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "編集") { (action, index) -> Void in
            
//            tableView.isEditing = false
//            print("archive")
//            
//            let storyboard: UIStoryboard = self.storyboard!
//            let detailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
//            detailViewController.id = self.reminderResults![(indexPath as NSIndexPath).row].id
//            self.present(detailViewController, animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "toShowDetail", sender:  self.reminderResults![(indexPath as NSIndexPath).row].id)
        }
        editButton.backgroundColor = UIColor.gray
        
        return [completeOrTaskButton, deleteButton, editButton]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if appDelegate.fromPage == "showTask" {
            pagename.title = "未実行タスク一覧"
            reminderResults = realm.objects(ReminderModel.self).filter("doflg == false").sorted(byProperty: "id", ascending: false)
        } else if appDelegate.fromPage ==  "showComplete" {
            pagename.title = "完了済みタスク一覧"
            reminderResults = realm.objects(ReminderModel.self).filter("doflg == true").sorted(byProperty: "id", ascending: false)
            pagename.rightBarButtonItem?.tintColor = UIColor.gray
        } else if appDelegate.fromPage ==  "showTaskCategory" {
            pagename.title = "カテゴリ別未実行タスク一覧"
            reminderResults = realm.objects(ReminderModel.self).filter("doflg == false").filter("category_id == \(category_id)").sorted(byProperty: "id", ascending: false)
        } else if appDelegate.fromPage ==  "showCompleteCategory" {
            pagename.title = "カテゴリ別完了済みタスク一覧"
            reminderResults = realm.objects(ReminderModel.self).filter("doflg == true").filter("category_id == \(category_id)").sorted(byProperty: "id", ascending: false)
            pagename.rightBarButtonItem?.tintColor = UIColor.gray
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let storyboard: UIStoryboard = self.storyboard!
//        let detailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
//        detailViewController.id = self.reminderResults![(indexPath as NSIndexPath).row].id
//        self.present(detailViewController, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "toShowDetail", sender:  self.reminderResults![(indexPath as NSIndexPath).row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowDetail" {
            let detail = segue.destination as! DetailViewController
            detail.id = sender as! Int
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let val = reminderResults {
             return val.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "reminderCell")
        
        if let dueDate = reminderResults![(indexPath as NSIndexPath).row].mydate {
            let now = Date()
            if dueDate.compare(now) == ComparisonResult.orderedAscending {
                cell.textLabel?.textColor = UIColor.red
            }
        }
        
        cell.textLabel?.text = reminderResults![(indexPath as NSIndexPath).row].title
        
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        cell.detailTextLabel?.text = formatter.string(from: reminderResults![(indexPath as NSIndexPath).row].mydate!)
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(reminderResults![(indexPath as NSIndexPath).row])
            try! realm.commitWrite()
            
            //tabelのセルをアニメーションで消す
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
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
