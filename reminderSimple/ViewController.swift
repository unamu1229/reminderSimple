//
//  ViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/07/17.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
     var myEventStore: EKEventStore! = EKEventStore()
     var myPlan: String!
    var myDate: NSDate! = NSDate()

    @IBOutlet weak var inputForm: UITextField!
    
    @IBAction func datePicker(sender: UIDatePicker) {
    }
    
    @IBAction func registar(sender: AnyObject) {
        myPlan = inputForm.text
        setMyPlanToReminder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //ユーザーにカレンダーの使用許可を求める
        allowAuthorization()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAuthorization_status() -> Bool {
        
        let status: EKAuthorizationStatus = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch status {
        case EKAuthorizationStatus.NotDetermined:
            print("NotDetermined")
            return false
            
        case EKAuthorizationStatus.Denied:
            print("Denied")
            return false
            
        case EKAuthorizationStatus.Authorized:
            print("Authorized")
            return true
            
        case EKAuthorizationStatus.Restricted:
            print("Restricted")
            return false
            
        default:
            print("error")
            return false
        }
        
    }
    
    /*
     認証許可.
     */
    func allowAuthorization() {
        
        // 許可されていなかった場合、認証許可を求める.
        if getAuthorization_status() {
            return
        } else {
            
            // ユーザーに許可を求める.
            myEventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                (granted , error) -> Void in
                
                // 許可を得られなかった場合アラート発動.
                if granted {
                    return
                }
                else {
                    
                    // メインスレッド 画面制御. 非同期.
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // アラート生成.
                        let myAlert = UIAlertController(title: "許可されませんでした", message: "Privacy->App->Reminderで変更してください", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        // アラートアクション.
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    func setMyPlanToReminder() {
        
        // イベントを作成する.
        let myReminder = EKReminder(eventStore: myEventStore)
        //let  myTargetCalendar = EKCalendar(forEntityType: EKEntityType.Reminder, eventStore: myEventStore)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromNSDate(myDate)
        myReminder.dueDateComponents = dueDateComponents
        myReminder.title = myPlan
        myReminder.calendar = myEventStore.defaultCalendarForNewReminders()
        // 一日中.
        // myEvent.allDay = true
        
        // イベントを保存.
        
        let result: Bool
        do {
            try myEventStore.saveReminder(myReminder, commit: true)
            result = true
        } catch let error1 as NSError {
            print(error1)
            result = false
        }
        
        // 保存成功・不成功でアラート発生.
        if result {
            
            let myAlert = UIAlertController(title: "保存に成功しました", message: "\(myPlan)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAlertAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        } else {
            
            let myAlert = UIAlertController(title: "保存に失敗しました", message: " \(myPlan)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAlertAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
}

