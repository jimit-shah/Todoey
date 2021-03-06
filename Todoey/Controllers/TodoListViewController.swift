//
//  ViewController.swift
//  Todoey
//
//  Created by Jimit Shah on 1/26/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

import UIKit
import CoreData

// MARK: - TodoListViewController: UITableViewController

class TodoListViewController: UITableViewController {
  
  // MARK: Properties
  
  var itemArray = [Item]()
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
  // MARK: Actions
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todo Item", message: nil, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { action in
      self.addNewItem(with: textField.text!)
    }
    
    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    print(dataFilePath)
  }
  
  // MARK: Helper Methods
  
  func addNewItem(with string: String) {
    if string.isEmpty { return }
    
    let newItem = Item(context: context)
    newItem.title = string.capitalized
    newItem.done = false
    newItem.category = selectedCategory
    itemArray.append(newItem)
    
    saveItems()
  }
  
  // MARK: Model Manupulation Methods
  
  func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
    tableView.reloadData()
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }
    
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context, \(error)")
    }
    tableView.reloadData()
  }
  
}

// MARK: - Tableview Datasource Methods

extension TodoListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let item = itemArray[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }
}

// MARK: - Tableview Delegates Methods

extension TodoListViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
      
      // delete item at indexPath
      self.context.delete(self.itemArray[indexPath.row])
      self.itemArray.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      self.saveItems()
      completionHandler(true)
    }
//    action.image = #imageLiteral(resourceName: "trash")
    
    let configuration = UISwipeActionsConfiguration(actions: [action])
    return configuration
  }
  
}

// MARK: - SearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
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

