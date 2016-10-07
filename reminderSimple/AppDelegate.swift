//
//  AppDelegate.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/07/17.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import Firebase
import UIKit
import CoreData
import EventKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myNavigationController: UINavigationController!
    var timer:Timer?
   // let myReminder = ReminderController()
    
    func dateComponentFromNSDate(_ date: Date)-> DateComponents{
        
        let calendarUnit: NSCalendar.Unit = [.minute, .hour, .day, .month, .year]
        let dateComponents = (Calendar.current as NSCalendar).components(calendarUnit, from: date)
        return dateComponents
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        // Initialize Google Mobile Ads SDK
        GADMobileAds.configure(withApplicationID: GADMobileAdsWithApplicationID)
        
        
        //初期画面とタスク一覧画面にナビゲーションエリアを表示し、タスク一覧画面ではBackボタンを表示する
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController: UIViewController = (storyboard.instantiateInitialViewController() as UIViewController?)!
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.myNavigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = myNavigationController
        self.window?.makeKeyAndVisible()
        
        //通知アクションの設定
        var complete = UIMutableUserNotificationAction()
        complete.identifier = "complete"
        complete.title = "実行済み"
        complete.activationMode = UIUserNotificationActivationMode.background
        
        var Incomplete = UIMutableUserNotificationAction()
        Incomplete.identifier = "Incomplete"
        Incomplete.title = "未完了"
        Incomplete.activationMode = UIUserNotificationActivationMode.background
        
        var category = UIMutableUserNotificationCategory()
        category.identifier = "reminder"
        category.setActions([complete, Incomplete], for: UIUserNotificationActionContext.default)
        
        //プッシュ通知の設定の許可を求める
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(types: [.sound, .badge, .alert], categories: Set([category]))
        )
        
        let config = Realm.Configuration(
        schemaVersion: 5,
        migrationBlock: { migration, oldSchemaVersion in
            if(oldSchemaVersion < 5){
            	
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
//		let realm = try! Realm()

        return true
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void){
        
        if let id = notification.userInfo?["id"]{
            let realm = try! Realm()
            let reminders = realm.objects(ReminderModel).filter("id == %@", id)
            for reminder in reminders {
                try! realm.write {
                    if(identifier! == "complete"){
                        reminder.doflg = true
                        reminder.alertflg = true
                    } else if (identifier! == "Incomplete"){
                    	reminder.alertflg = true
                    }
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        timer?.invalidate()
        
        let realm = try! Realm()
        let reminderResults = realm.objects(ReminderModel.self).filter("doflg == false")

        var arrNotification:[UILocalNotification] = []
        var badgeCount = 0
        let now = Date()
        for reminder in reminderResults {
            let notification = UILocalNotification()
            notification.alertBody = reminder.title
            notification.fireDate = reminder.mydate
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.category = "reminder"
            notification.userInfo = ["id":reminder.id]
            let now = Date()
            //NSComparisonResult.OrderedSameで同じ時間を検知したかったができなかった
            //のでフラグで管理することにした。
            if reminder.mydate!.compare(now) == ComparisonResult.orderedAscending {
                badgeCount += 1
            }
            arrNotification.append(notification)
        }
        //バッチの数字を設定する
        application.applicationIconBadgeNumber = badgeCount
        //イベントの通知スケジュールを設定する
        application.scheduledLocalNotifications = arrNotification
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.updateAlert), userInfo: nil, repeats: true)
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
        if let vc = self.window?.rootViewController {
            print("5555")
            vc.present(myAlert, animated: true, completion: nil)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "hiroshi.yoneda.reminderSimple" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "reminderSimple", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

