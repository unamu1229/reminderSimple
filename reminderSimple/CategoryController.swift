//
//  CategoryController.swift
//  reminderSimple
//
//  Created by 米田宏 on 2016/10/10.
//  Copyright © 2016年 hiroshiyoneda. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryController: UIViewController {

    @IBOutlet weak var input: UITextField!
    
    @IBAction func addCategory() {
        self.view.endEditing(true)
        let title = input.text!
        setCategory(title)
    }
    
    func setCategory(_ title:String){
        let myAlert:UIAlertController!
        if (title != ""){
            let categoryModel = CategoryModel()
            categoryModel.id = categoryModel.lastId()
            categoryModel.title = title
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.add(categoryModel)
                }
                myAlert = UIAlertController(title: "保存に成功しました", message: title, preferredStyle: UIAlertControllerStyle.alert)
                input.text = ""
            } catch {
                myAlert = UIAlertController(title: "保存に失敗しました", message: title, preferredStyle: UIAlertControllerStyle.alert)
            }
        } else {
            myAlert = UIAlertController(title: "カテゴリ名を入力してください", message: "", preferredStyle: UIAlertControllerStyle.alert)
        }
        let okAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAlertAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
