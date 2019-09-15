//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shanshan Gao on 2019/8/27.
//  Copyright © 2019 Shanshan Gao. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  
  let realm = try! Realm()
  var categories: Results<Category>?

  override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
  }

  // MARK: - Add New Categories

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    var textField = UITextField()
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    let action = UIAlertAction(title: "Add category", style: .default) { (action) in
      let newCategory = Category()
      newCategory.name = textField.text ?? "New category"
      self.save(category: newCategory)
      
      self.tableView.reloadData()
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - TableView Datasoure Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
    return cell
  }
  
  //MARK: - Data Manipulation Methods
  
  private func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving category \(error)")
    }
    tableView.reloadData()
  }
  
  private func loadCategories() {
    categories = realm.objects(Category.self)
    tableView.reloadData()
  }
  
  //MARK: - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
}
