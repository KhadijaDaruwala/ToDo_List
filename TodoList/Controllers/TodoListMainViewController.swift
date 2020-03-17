//
//  TodoListMainViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 12/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListMainViewController: UITableViewController {
    
    var itemArray: Results<Item>?
    let cellIndetifier = "toDoItemCell"
    let relam = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Tableview data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath)
        let item = itemArray?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "No items added yet"
        cell.accessoryType = item?.done == true ?  .checkmark : .none
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            do {
                try relam.write(){
                    item.done = !item.done
                }
            }catch{
                print("Error while saving done status \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add button
    @IBAction func buttonAddItems(_ sender: Any) {
        var itemTextfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try self.relam.write(){
                        let newItem = Item()
                        newItem.title = itemTextfield.text!
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving data \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Enter item"
            itemTextfield = alertTextfield
        }
        alert.addAction(action)
        
        present(alert, animated:true, completion: nil)
    }
    
    
    //MARK: Data manipulation
    func loadItems(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
}

////MARK: Search bar delegate methods
//extension TodoListMainViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        var predicate: NSPredicate?
//
//        if let searchText = searchBar.text, searchText != ""{
//            predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        }
//        loadItems(with: request, predicate: predicate!)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

