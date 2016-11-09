//
//  CategoryTableViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/10/26.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var CategoryResults:Results<CategoryModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let realm = try! Realm()
//        CategoryResults = realm.objects(CategoryModel.self).sorted(byProperty: "id", ascending: false)
        let category = Category()
        CategoryResults = category.CategoryResults
        for category in CategoryResults! {
            print(category.title)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let val = CategoryResults {
            return val.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "categoryCell")
		cell.textLabel?.text = CategoryResults![(indexPath as NSIndexPath).row].title
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toCategoryTask", sender:  CategoryResults![(indexPath as NSIndexPath).row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoryTask"{
            let categoryTask = segue.destination as! TableViewController
            categoryTask.category_id = sender as! Int
            if appDelegate.fromPage.range(of: "Category") == nil {
                appDelegate.fromPage += "Category"
            }
        } else if segue.identifier == "showAddCategory"{
            let categoryController = segue.destination as! CategoryController
            if let id = sender as? Int {
                categoryController.id = id
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Deleteボタン.
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            tableView.isEditing = false
            // Delete the row from the data source
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(self.CategoryResults![(indexPath as NSIndexPath).row])
            try! realm.commitWrite()
            
            //tabelのセルをアニメーションで消す
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        deleteButton.backgroundColor = UIColor.red
        
        // 編集ボタン.
        let editButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "編集") { (action, index) -> Void in
            self.performSegue(withIdentifier: "showAddCategory", sender:  self.CategoryResults![(indexPath as NSIndexPath).row].id)
        }
        editButton.backgroundColor = UIColor.gray
        
        return [deleteButton, editButton]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
