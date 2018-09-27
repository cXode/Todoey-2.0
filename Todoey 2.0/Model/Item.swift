//
//  Item.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 26/09/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
