//
//  PostModel.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 19.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import Foundation
import RealmSwift



class PostModel{
    
    let requestService = RequestsService()
    let dbManager = DBManager()
    private var count = 0
    let batchSize = 2
    var timer = Timer()
    
    init(){
        
    }
    //MARK:- start/stop Download on timer
    func startDownlodTimer()->String{
        if !timer.isValid{
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(downloadPosts), userInfo: nil, repeats: true)
            return "Stop Timer"
        }else{
            timer.invalidate()
            return "Start Timer"
        }
    }
    
    //MARK:- get all data from DB
    func getAllPosts<P:Object>(ofType: P.Type)->[P]{
        guard let tmp = dbManager.getDataFromDB(type: ofType)
            else {return []}
        return Array(tmp)
    }
    
    //MARK:- subscride
    func subscribe<P: Object>(myTableView: UITableView,type: P.Type){
        dbManager.subscribe(tableView: myTableView, type: type)
    }
    
    //MARK:- add data to DB
    func addPostToDB<P: Object>(post: P) where P: MyObject{
        dbManager.addData(object: post)
    }
    
    //MARK:- change post in DB
    func changePostInDB<P: Object>(object: P, type: P.Type) where P: MyObject{
        dbManager.changeData(object: object, type: type)
    }
    
    //MARK:- get post by id
    func getPost<P: Object>(id: String, type: P.Type) -> P?{
        let tmp = dbManager.getItem(id:id, type: type)
        return tmp
    }
    
    //MARK:- delete objewct from db
    func deleteFromDB<P:Object>(object: P){
        count -= 1
        dbManager.deleteFromDb(object: object)
    }
    
    //MARK:- delete all data from DB
    func deleteAllDB(){
        count = 0
        dbManager.deleteAllDatabase()
    }
    
    func getItemsCount<P:Object>(type: P.Type)-> Int{
        return dbManager.getCount(type: type)
    }
    
    //MARK:- Sownload batchSize count posts
    @objc func downloadPosts(){
        DispatchQueue(label: "background").async {
            /// Для оперативной очистки памяти
            autoreleasepool {
                
                //                        self.count = self.getItemsCount(type: MyItem.self)
                
                self.requestService.sendGetReqest(
                    //                    type: CommonReq.self,
                    type: [Post].self,
                    endPoint: "/posts?_start=\(String(self.count))&_limit=\(String(self.batchSize))",
                    completion: { res  in
                        self.count += self.batchSize
                        for tmp in res {
                            let item = MyItem()
                            item.textString = tmp.title
                            item.id = String(tmp.id)
                            self.addPostToDB(post: item)
                        }
                },
                    failure: { error in
                        DispatchQueue.main.async {
                            print(error)
                            //err
                        }
                })
            }
        }
    }
}
