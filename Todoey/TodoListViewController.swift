//
//  ViewController.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/7/7.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  let itemArray = ["Find Mike", "Buy Eggs", "DestroyDemogoaht" ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  //MARK  - TableViewDelegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cell = tableView.cellForRow(at: indexPath)
    if cell?.accessoryType == .checkmark {
      cell?.accessoryType = .none
    } else {
      cell?.accessoryType = .checkmark
    }
  }
}

