//
//  ViewController.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/7/7.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

  var todoItems: Results<Item>?
  let realm = try! Realm()
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Item Added"
    }
    return cell
  }
  
  //MARK: - TableViewDelegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      }
    }
    tableView.reloadData()
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
    var textField = UITextField()
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    let action = UIAlertAction(title: "Add item", style: .default) { (action) in
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text ?? "New item"
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
            self.realm.add(newItem)
          }
        } catch {
          print("Error adding item.")
        }
      }
      self.tableView.reloadData()
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
  }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!)
        .sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}

