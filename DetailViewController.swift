//
//  DetailViewController.swift
//  
//
//  Created by 米田宏 on 2016/09/10.
//
//

import UIKit
import RealmSwift

class DetailViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var id = Int()
    var fromPage = ""
    var lastRow = Int()
    @IBOutlet weak var textData: UITextView!
    let realm = try! Realm()
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var cetegoryPicker: UIPickerView!
    
    var categoryId = Int()
    var selectRow = [Int: Int]()
    var MPRC = MapPickerRowCategory()
    
    let category = Category()
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textData.sizeToFit()
        let reminders = realm.objects(ReminderModel).filter("id == %@", id)
        for reminder in reminders {
            textData.text = reminder.title
            datepicker.date = reminder.mydate!
            let row = MPRC.getPickerRow(categoryId: reminder.category_id)
            cetegoryPicker.selectRow(row, inComponent: 0, animated: true)
//            if let row = selectRow[reminder.category_id] {
//                cetegoryPicker.selectRow(row, inComponent: 0, animated: true)
//            }
            categoryId = reminder.category_id
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let reminders = realm.objects(ReminderModel).filter("id == %@", id)
        for reminder in reminders {
            try! realm.write {
             	reminder.title = textData.text
                reminder.mydate = datepicker.date
                reminder.category_id = categoryId
            }
        }
    }
    
    func numberOfComponents(in picekrView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let category = Category()
        if var count = category.CategoryResults?.count{
            lastRow = count
            count += 1
            return count
        }
        return 0
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row:Int, forComponent component: Int) -> String? {        
//        if lastRow == row {
//            return "未分類"
//        } else {
            MPRC.addMapPickerRowCategory(row: row)
            //selectRow[(category.CategoryResults?[row].id)!] = row
        	//return category.CategoryResults?[row].title
            return MPRC.getCategoryTitle(row: row)
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryId = MPRC.getCategoryId(row: row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let category = segue.destination as! CategoryTableViewController
	        category.fromPage = fromPage
    }
    
}
