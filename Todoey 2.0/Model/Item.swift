//
//  Items.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 22/08/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import Foundation

//MARK: - 4.3 Moramo postaviti ovaj class kao encodable i decodable da bi on mogao bit enkodiran u plist ili json te dekodiran
class Item : Codable{
    var title : String = ""
    var done : Bool = false
}
