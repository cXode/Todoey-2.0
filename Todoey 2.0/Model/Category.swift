//
//  Category.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 26/09/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
