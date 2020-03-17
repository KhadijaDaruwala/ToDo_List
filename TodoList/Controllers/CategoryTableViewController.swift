//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 16/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categoriesArray: Results<Category>?
    let cellIdentifier = "categoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    // MARK: - Table view data source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoriesArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            if let color = UIColor(hexString: category.bgColor){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No category added yet"
        }
        
        return cell
    }
    
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListMainViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVc.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
    
    //MARK: Add new items
    @IBAction func addCategoryClicked(_ sender: UIBarButtonItem) {
        var categoryTextfield = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let newCategory = Category()
            newCategory.name = categoryTextfield.text!
            newCategory.bgColor = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter category"
            categoryTextfield = textfield
        }
        
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    //MARK: Data manipulation
    
    func save(category: Category){
        do {
            try realm.write(){
                realm.add(category)
            }
        }catch {
            print("Error while saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(){
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Delete data
    override func updateDataModel(at indexPath: IndexPath) {
        if let category = self.categoriesArray{
            do{
                try self.realm.write(){
                    self.realm.delete(category[indexPath.row])
                }
            }catch{
                print("Error while deleting category \(error)")
            }
            //    tableView.reloadData()
        }
    }
}

