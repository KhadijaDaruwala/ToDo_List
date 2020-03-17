//
//  Category.swift
//  TodoList
//
//  Created by Khadija Daruwala on 17/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = "#FFFFFF"
    let items = List<Item>()
}
