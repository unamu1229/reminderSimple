//
//  CategoryModel.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/10/10.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import RealmSwift

class CategoryModel:Object {
    dynamic var id = Int()
    dynamic var title = ""
    open func lastId() -> Int {
        let realm = try! Realm()
        if let categoryLast = realm.objects(CategoryModel).sorted(byProperty: "id").last {
            return categoryLast.id + 1
        } else {
            return 1
        }
    }
}
