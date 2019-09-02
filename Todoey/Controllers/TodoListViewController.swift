//
//  ViewController.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/7/7.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }
  
  //MARK: - TableViewDelegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
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
      let newItem = Item(context: self.context)
      newItem.title = textField.text ?? "New item"
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      self.itemArray.append(newItem)
      self.saveItems()
      
      self.tableView.reloadData()
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error encoding item array, \(error)")
    }
  }
  
  private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
                         predicate: NSPredicate? = nil) {
    let categoryPredicate =
          NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,
                                                                              additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    } 
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetch data from context \(error)")
    }
    tableView.reloadData()
  }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    loadItems(with: request, predicate: predicate)
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

