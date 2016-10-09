//
//  ReminderModel.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/08/29.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import RealmSwift

class ReminderModel:Object {
    dynamic var id = Int()
    dynamic var title = ""
    dynamic var mydate:Date?
    dynamic var alertflg = false
    dynamic var doflg = false
    
    open func lastId() -> Int {
        let realm = try! Realm()
        if let remenberLast = realm.objects(ReminderModel).sorted(byProperty: "id").last {
            return remenberLast.id + 1
        } else {
            return 1
        }
    }
}
