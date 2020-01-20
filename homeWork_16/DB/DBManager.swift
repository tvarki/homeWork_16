//
//  DBManager.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 18.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import Foundation
import RealmSwift

protocol TableViewChangesDelegate: AnyObject {
    
    func updateTreeView(deletions: [Int], insertions: [Int], modifications: [Int])
    func reloadTreeView()
    func showError(error:String)
}

class DBManager {
    
    private var database:Realm?
//    static let sharedInstance = DBManager()
    var notificationToken: NotificationToken? = nil
    
    
    init() {
        setupRealm()
    }
    
    //MARK:- Realm SetuP
    func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,

            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                  
                }
            }
        )
        /// Для всех рилмов указываем глобальную конфигурацию
        Realm.Configuration.defaultConfiguration = config

        database = try? Realm()
    }
    
    
    func getDataFromDB<P:Object>(type: P.Type) -> Results<P>? {
        guard let database = database else { return nil}
//        let results: Results<P> = database.objects(type).sorted(byKeyPath: "id", ascending: true)
        let results: Results<P> = database.objects(type)
        return results
    }
    
    func addData<P:Object>(object: P) where P: MyObject {
        
        DispatchQueue(label: "realmBackground").async {
            /// Для оперативной очистки памяти
            autoreleasepool {
                // Инстанс рилма должен быть свой для каждой очереди
                guard let database = try? Realm() else { return }
                
                let item = database.objects(P.self).filter("id = %@", object.id).first
                if item == nil {
                    try? database.write {
                        database.add(object)
//                        print("Added new object")
                    }
                }
            }
        }
    }
    
    func getItem<P: Object>(id: String, type: P.Type) -> P? {
        guard let database = database else { return nil}

        let tmp = database.objects(type).filter("id = %@", id).first
        return tmp
    }
    
    func changeData<P: Object> (object:P, type: P.Type) where P: MyObject{
        guard let database = database else { return }
        var item = database.objects(type).filter("id = %@", object.id).first
        try? database.write {
            item?.textString = object.textString
            return
        }
    }
        
    func deleteAllDatabase()  {
        guard let database = database else { return }
        
        try? database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb<P:Object>(object: P) {
        guard let database = database else { return }
        
        try? database.write {
            
            database.delete(object)
        }
    }
    
    
    //MARK:- Realm subscribe

    func subscribe<P:Object>(tableView : UITableView?, type: P.Type ) {
        guard let database = database else { return }
        let results = database.objects(type)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(
                    at: deletions.map({ IndexPath(row: $0, section: 0)}),
                    with: .automatic
                )
                tableView.insertRows(
                    at: insertions.map({ IndexPath(row: $0, section: 0) }),
                    with: .automatic
                )
                tableView.reloadRows(
                    at: modifications.map({ IndexPath(row: $0, section: 0) }),
                    with: .automatic
                )
                tableView.endUpdates()
//                tableView.reloadData()

            case .error(let error):
                /// Ошбика может возникнуть только если Realm был создан на бэкграунд очереди
                fatalError("\(error)")
            }
        }
    }
    
    
    func getCount<P:Object>(type: P.Type)->Int{
        guard let database = try? Realm() else { return 0}
        let items = database.objects(type)
        return items.count
    }
}
