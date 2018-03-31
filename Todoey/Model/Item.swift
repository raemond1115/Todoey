//
//  Item.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/29/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
