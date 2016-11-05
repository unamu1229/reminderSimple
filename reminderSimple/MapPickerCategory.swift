//
//  MapPickerCategory.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/11/05.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//
import RealmSwift

struct MapPickerRowCategory {
    var arrMapPickerRowCategory = [0 : CategoryIdTitle(id:0, title:"未設定")]
    let category = Category()
    
    mutating func addMapPickerRowCategory(row: Int){
        let deletedRow = row - 1
        if deletedRow != -1 {
            if let result = category.CategoryResults?[deletedRow] {
                self.arrMapPickerRowCategory[row] = CategoryIdTitle(id:result.id, title:result.title)
                
            } else {
                self.arrMapPickerRowCategory[row] = CategoryIdTitle(id:0, title:"未設定")
            }
        }
    }

    func getCategoryId(row: Int) -> Int {
        let categoryId = arrMapPickerRowCategory[row]?.id
        return categoryId!
    }
    
    func getCategoryTitle(row: Int) -> String {
        let categoryTitle = arrMapPickerRowCategory[row]?.title
        return categoryTitle!
    }
    
    func getPickerRow(categoryId: Int) -> Int {
        for (pickerRow, categoryIdTitle) in arrMapPickerRowCategory {
            if(categoryIdTitle.id == categoryId){
                return pickerRow
            }
        }
        return 0
    }
    
    func getPickerRowCount() -> Int {
        if var count = category.CategoryResults?.count{
            count += 1
            return count
        }
        return 1
    }
}

struct CategoryIdTitle {
    var id: Int
    var title: String
    init(id: Int, title: String){
        self.id = id
        self.title = title
    }
}
