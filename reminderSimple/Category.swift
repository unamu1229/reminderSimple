//
//  Category.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/10/29.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import RealmSwift

class Category {
    
    var CategoryResults:Results<CategoryModel>?
    
    init(){
        let realm = try! Realm()
        CategoryResults = realm.objects(CategoryModel.self).sorted(byProperty: "id", ascending: false)
    }
    
}
