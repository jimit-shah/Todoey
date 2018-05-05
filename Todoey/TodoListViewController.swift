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
  
  var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
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
    
    if let items = defaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
  }
  
  // MARK: Helper Methods
  
  private func addNewItem(with string: String) {
    if string.isEmpty {
      return
    }
    itemArray.append(string.capitalized)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
}

// MARK: - Tableview Delegates Methods

extension TodoListViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = (cell.accessoryType == .none) ? .checkmark : .none
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}



