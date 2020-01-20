//
//  SecondViewController.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 18.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var currentItem: MyItem?
    
    var postModel : PostModel?
    
    @IBOutlet var txtNote: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = currentItem {
            txtNote.text = item.textString
        }
    }
    
    //MARK:- actions
    @IBAction func saveButtonClicked(_ sender: Any) {
        let item = MyItem()
        if(currentItem == nil) {
            item.id = UUID().uuidString
            item.textString = txtNote.text!
            postModel?.addPostToDB(post: item)
        }else{
            item.id = currentItem!.id
            item.textString = txtNote.text!
            postModel?.changePostInDB(object: item, type: MyItem.self)
        }
        self.dismiss(animated: true) { }
        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if let item = currentItem {
            postModel?.deleteFromDB(object: item)
            self.dismiss(animated: true) { }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
