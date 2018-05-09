//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jimit Shah on 5/8/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  // MARK: Properties
  var categories = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  // MARK: Actions
  
  @IBAction func addButtonPressed(_ sender: Any) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { action in
      self.addNewCategory(with: textField.text!)
    }
    
    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  // MARK: Helper Methods
  
  func addNewCategory(with string: String) {
    if string.isEmpty { return }
    
    let newCategory = Category(context: context)
    newCategory.name = string.capitalized
    
    categories.append(newCategory)
    saveCategories()
  }
  
  // MARK: - Data Manipulation Methods
  
  // MARK: Save Categories
  
  func saveCategories() {
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
    tableView.reloadData()
  }
  
  // MARK: Load Categories
  
  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categories = try context.fetch(request)
    } catch {
      print("Error loading categories from context, \(error)")
    }
    tableView.reloadData()
  }
  
  // MARK: - TableView DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    return cell
  }
  
  
  // MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard segue.identifier == "goToItems" else { return }
    
    let destinationVC = segue.destination as! TodoListViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories[indexPath.row]
    }
    
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
      
      // delete item at indexPath
      self.context.delete(self.categories[indexPath.row])
      self.categories.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      self.saveCategories()
    }
    return [delete]
  }
  
}

