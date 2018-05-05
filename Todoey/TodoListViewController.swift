//
//  ViewController.swift
//  Todoey
//
//  Created by Jimit Shah on 1/26/18.
//  Copyright © 2018 Jimit Shah. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
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
