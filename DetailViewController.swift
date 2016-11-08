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
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var id = Int()
    let realm = try! Realm()
    var reminders:Results<ReminderModel>!
    var categoryId = Int()
    var MPRC = MapPickerRowCategory()
    
    @IBOutlet weak var textData: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var cetegoryPicker: UIPickerView!
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    @IBOutlet weak var cateBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if appDelegate.fromPage ==  "showComplete" || appDelegate.fromPage ==  "showCompleteCategory" {
            cateBtn.tintColor = UIColor.gray
        }
        textData.sizeToFit()
        reminders = realm.objects(ReminderModel).filter("id == %@", id)
        textData.text = reminders[0].title
        datepicker.date = reminders[0].mydate!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let row = MPRC.getPickerRow(categoryId: reminders[0].category_id)
        cetegoryPicker.selectRow(row, inComponent: 0, animated: true)
        categoryId = reminders[0].category_id
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
        let count = MPRC.getPickerRowCount()
        return count
    }
    
    func pickerView(_ pickerView:UIPickerView, titleForRow row:Int, forComponent component: Int) -> String? {
            MPRC.addMapPickerRowCategory(row: row)
            return MPRC.getCategoryTitle(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryId = MPRC.getCategoryId(row: row)
    }
    
}
