//
//  ViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/07/17.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import EventKit
import RealmSwift
import iAd

class ViewController: UIViewController {
    
     var myEventStore: EKEventStore! = EKEventStore()
     var myPlan: String!
    var myDate: NSDate! = NSDate()

    @IBOutlet weak var inputForm: UITextField!
    
    @IBAction func datePicker(sender: UIDatePicker) {
        didChangeDate(sender)
       
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func registar(sender: AnyObject) {
        myPlan = inputForm.text
        setMyPlanToReminder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.canDisplayBannerAds = true
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.updateAlert), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     DatePickerの値が変わった時に呼び出されるメソッド.
     */
    func didChangeDate(sender: UIDatePicker) {
        let myDateFormatter = NSDateFormatter()
        myDateFormatter.timeStyle = .ShortStyle
        myDateFormatter.dateStyle = .ShortStyle
        let mySelectDateString = myDateFormatter.stringFromDate(sender.date)
        let mySelectDate = myDateFormatter.dateFromString(mySelectDateString)!
        
        myDate = NSDate(timeInterval: 0, sinceDate: mySelectDate)
    }
    
    func updateAlert(){
        let realm = try! Realm()
        let reminderResults = realm.objects(ReminderModel.self)        
        for reminder in reminderResults {
            if reminder.alertflg == false {
                if let dueDate = reminder.mydate {
                    let now = NSDate()
                    //NSComparisonResult.OrderedSameで同じ時間を検知したかったができなかった
                    //のでフラグで管理することにした。
                    if dueDate.compare(now) == NSComparisonResult.OrderedAscending {
                        self.alert(reminder.title)
                        try! realm.write {
                            reminder.alertflg = true
                        }
                    }
                }
            }
        }
    }
    
    func alert(title:String){
        let myAlert = UIAlertController(title: title, message: "やりなさい", preferredStyle: .Alert)
        let myAction = UIAlertAction(title:"やります", style:  .Default, handler: nil)
        myAlert.addAction(myAction)
        presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func setMyPlanToReminder() {
        
        let myAlert:UIAlertController!
        
        if(myPlan == ""){
            myAlert = UIAlertController(title: "タスクを入力してください", message: "\(myPlan)", preferredStyle: UIAlertControllerStyle.Alert)
        } else {
            let reminderModel = ReminderModel()
            reminderModel.id = reminderModel.lastId()
            reminderModel.title = myPlan
            reminderModel.mydate = myDate
            let realm = try! Realm()
            print(realm.configuration.fileURL)
            
            do {
                try realm.write {
                    realm.add(reminderModel)
                }
                myAlert = UIAlertController(title: "保存に成功しました", message: "\(myPlan)", preferredStyle: UIAlertControllerStyle.Alert)
            } catch {
                myAlert = UIAlertController(title: "保存に失敗しました", message: " \(myPlan)", preferredStyle: UIAlertControllerStyle.Alert)
            }
            
        }
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAlertAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}

