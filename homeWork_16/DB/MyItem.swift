//
//  MyItem.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 18.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import Foundation
import RealmSwift

class MyItem: Object, MyObject{
    
    @objc dynamic var id  = ""
    @objc dynamic var textString = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

//MARK:- Protocol for calling id or textString from generic object

protocol MyObject{
    dynamic var id: String { get set }
    dynamic var textString: String { get set }
}
