//
//  TodoListMainViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 12/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit

class TodoListMainViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggs", "Buy Chocolates"]
let cellIndetifier = "toDoItemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
}
