//
//  ReminderModel.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/08/29.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import RealmSwift

class ReminderModel:Object {
    dynamic var title = ""
    dynamic var mydate:NSDate?
    dynamic var alertflg = false
}
