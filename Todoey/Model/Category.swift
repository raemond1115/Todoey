//
//  Category.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/29/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name:String = ""
    let items: List<Item> = List<Item>()
}
