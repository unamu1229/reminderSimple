//
//  ViewController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/07/17.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import GoogleMobileAds
import UIKit
import EventKit
import RealmSwift
import iAd

class ViewController: UIViewController {
    
     var myEventStore: EKEventStore! = EKEventStore()
     var myPlan: String!
     var myDate: Date! = Date()

    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var inputForm: UITextField!    
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        didChangeDate(sender)
       
    }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func registar(_ sender: AnyObject) {
        myPlan = inputForm.text
        self.view.endEditing(true)
        setMyPlanToReminder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.canDisplayBannerAds = true
        
        bannerView.adUnitID = BannerViewAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.adSize = kGADAdSizeBanner
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     DatePickerの値が変わった時に呼び出されるメソッド.
     */
    func didChangeDate(_ sender: UIDatePicker) {
        let myDateFormatter = DateFormatter()
        myDateFormatter.timeStyle = .short
        myDateFormatter.dateStyle = .short
        let mySelectDateString = myDateFormatter.string(from: sender.date)
        let mySelectDate = myDateFormatter.date(from: mySelectDateString)!
        
        myDate = Date(timeInterval: 0, since: mySelectDate)
    }
    
    func setMyPlanToReminder() {
        
        let myAlert:UIAlertController!
        
        if(myPlan == ""){
            myAlert = UIAlertController(title: "タスクを入力してください", message: "", preferredStyle: UIAlertControllerStyle.alert)
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
                myAlert = UIAlertController(title: "保存に成功しました", message: myPlan, preferredStyle: UIAlertControllerStyle.alert)
                inputForm.text = ""
            } catch {
                myAlert = UIAlertController(title: "保存に失敗しました", message: myPlan, preferredStyle: UIAlertControllerStyle.alert)
            }
            
        }
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAlertAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

