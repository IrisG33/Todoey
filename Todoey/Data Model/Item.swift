//
//  Item.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/9/8.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var dateCreated: Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
