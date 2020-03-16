//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Khadija Daruwala on 16/03/20.
//  Copyright © 2020 Khadija Daruwala. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let cellIdentifier = "categoryCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    // MARK: - Table view data source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListMainViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVc.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    
    //MARK: Add new items
    @IBAction func addCategoryClicked(_ sender: UIBarButtonItem) {
        var categoryTextfield = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let category = Category(context: self.context)
            category.name = categoryTextfield.text!
            self.categoriesArray.append(category)
            self.saveCategory()
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter category"
            categoryTextfield = textfield
        }
        
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
    }
    
    //MARK: Data manipulation
    
    func saveCategory(){
        do {
            try context.save()
        }catch {
            print("Error while saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoriesArray = try context.fetch(request)
        } catch{
            print("Error while fetching data \(error)")
        }
    }
}
