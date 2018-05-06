//
//  ViewController.swift
//  Todoey
//
//  Created by Jimit Shah on 1/26/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

import UIKit

// MARK: - TodoListViewController: UITableViewController

class TodoListViewController: UITableViewController {
  
  // MARK: Properties
  
  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
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
    
    let newItem = Item()
    newItem.title = "Find Mike"
    itemArray.append(newItem)
    
    let newItem2 = Item()
    newItem2.title = "Buy Eggos"
    itemArray.append(newItem2)
    
    let newItem3 = Item()
    newItem3.title = "Destroy Demogorgon"
    itemArray.append(newItem3)
    
    if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
      itemArray = items
    }
  }
  
  // MARK: Helper Methods
  
  private func addNewItem(with string: String) {
    if string.isEmpty {
      return
    }
    let newItem = Item()
    newItem.title = string.capitalized
    itemArray.append(newItem)
    defaults.set(itemArray, forKey: "TodoListArray")
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
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}



