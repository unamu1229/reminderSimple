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
 
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateAlert), userInfo: nil, repeats: true)

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
    
    func updateAlert(){
        let realm = try! Realm()
        let reminderResults = realm.objects(ReminderModel.self)        
        for reminder in reminderResults {
            if reminder.alertflg == false {
                if let dueDate = reminder.mydate {
                    let now = Date()
                    //NSComparisonResult.OrderedSameで同じ時間を検知したかったができなかった
                    //のでフラグで管理することにした。
                    if dueDate.compare(now) == ComparisonResult.orderedAscending {
                        self.alert(reminder.title)
                        try! realm.write {
                            reminder.alertflg = true
                        }
                    }
                }
            }
        }
    }
    
    func alert(_ title:String){
        let myAlert = UIAlertController(title: title, message: "やりなさい", preferredStyle: .alert)
        let myAction = UIAlertAction(title:"やります", style:  .default, handler: nil)
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    func setMyPlanToReminder() {
        
        let myAlert:UIAlertController!
        
        if(myPlan == ""){
            myAlert = UIAlertController(title: "タスクを入力してください", message: "\(myPlan)", preferredStyle: UIAlertControllerStyle.alert)
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
                myAlert = UIAlertController(title: "保存に成功しました", message: "\(myPlan)", preferredStyle: UIAlertControllerStyle.alert)
            } catch {
                myAlert = UIAlertController(title: "保存に失敗しました", message: " \(myPlan)", preferredStyle: UIAlertControllerStyle.alert)
            }
            
        }
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAlertAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

