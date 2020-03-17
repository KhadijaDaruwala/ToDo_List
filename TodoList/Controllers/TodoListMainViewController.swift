//
//  TodoListMainViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 12/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListMainViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: Results<Item>?
    let cellIndetifier = "toDoItemCell"
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let category = selectedCategory else {fatalError()}
        self.navigationItem.title = category.name
        updateNavBar(withHexCode: category.bgColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "#1D9BF6")
    }
    
    //MARK: Navigation bar setup methods
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}

        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        self.searchBar.barTintColor = navBarColor
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = UIColor.white
            
            //                            let navBarAppearance = UINavigationBarAppearance()
            //                            navBarAppearance.configureWithOpaqueBackground()
            //                            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            //                            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            //                            navBarAppearance.backgroundColor = UIColor(hexString: category.bgColor)
            //                            navBar.standardAppearance = navBarAppearance
            //                            navBar.scrollEdgeAppearance = navBarAppearance
            
        }
        
    }
    
    //MARK: Tableview data source methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ?  .checkmark : .none
            if let color =  UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(itemArray!.count))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            do {
                try realm.write(){
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
                    try self.realm.write(){
                        let newItem = Item()
                        newItem.title = itemTextfield.text!
                        newItem.dateCreated = Date()
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
    
    //MARK: Delete data
    override func updateDataModel(at indexPath: IndexPath) {
        if let item = self.itemArray{
            do{
                try self.realm.write(){
                    self.realm.delete(item[indexPath.row])
                }
            }catch{
                print("Error while deleting item \(error)")
            }
        }
    }
}

//MARK: Search bar delegate methods
extension TodoListMainViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text, searchText != ""{
            itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

