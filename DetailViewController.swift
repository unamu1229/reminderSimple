//
//  DetailViewController.swift
//  
//
//  Created by 米田宏 on 2016/09/10.
//
//

import UIKit
import RealmSwift

class DetailViewController:UIViewController {
    
    var id = Int()
    @IBOutlet weak var textData: UITextView!
    let realm = try! Realm()
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textData.sizeToFit()
        let reminders = realm.objects(ReminderModel).filter("id == %@", id)
        for reminder in reminders {
            textData.text = reminder.title
            datepicker.date = reminder.mydate!
         //   textData = reminder.title
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let reminders = realm.objects(ReminderModel).filter("id == %@", id)
        for reminder in reminders {
            try! realm.write {
             	reminder.title = textData.text
                reminder.mydate = datepicker.date
            }
        }
    }
    
    @IBAction func backPage(_ sender: AnyObject) {
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
