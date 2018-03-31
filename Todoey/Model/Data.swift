//
//  Data.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/28/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
