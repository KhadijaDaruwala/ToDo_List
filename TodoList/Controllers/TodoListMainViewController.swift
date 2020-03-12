//
//  TodoListMainViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 12/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit

class TodoListMainViewController: UITableViewController {
    
    var itemArray = [ItemModel]()
    let cellIndetifier = "toDoItemCell"
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = ItemModel()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = ItemModel()
        newItem1.title = "Buy Eggs"
        itemArray.append(newItem1)
        
        let newItem2 = ItemModel()
        newItem2.title = "Buy Chocolates"
        itemArray.append(newItem2)
        
        //        if let item = defaults.array(forKey: "todoListArray") as? [String]{
        //            itemArray = item
        //        }
    }
    
    
    //MARK: Tableview data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ?  .checkmark : .none
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add button
    @IBAction func buttonAddItems(_ sender: Any) {
        var itemTextfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let newItem = ItemModel()
            newItem.title = itemTextfield.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "todoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Enter item"
            itemTextfield = alertTextfield
        }
        alert.addAction(action)
        
        present(alert, animated:true, completion: nil)
    }
}
