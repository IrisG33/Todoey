//
//  Category.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/9/8.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  let items = List<Item>()
}
