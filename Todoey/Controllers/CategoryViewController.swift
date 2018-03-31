//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/26/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.rowHeight = 80.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("Successful")
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            print("New TextField")
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            print("Complete")
        }
    }

    // MARK: - Table view delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Maniuplate Methods

    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Saving Category Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let category = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch{
                print("Delete Category Error \(error)")
            }
            tableView.reloadData()
        }
    }

}

