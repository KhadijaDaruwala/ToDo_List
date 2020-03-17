//
//  Item.swift
//  TodoList
//
//  Created by Khadija Daruwala on 17/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
