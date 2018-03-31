//
//  ViewController.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/19/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    //var itemArray = ["Study iOS", "Study AWS", "Teach Celia", "Play with Norton"]
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = !item.done ? .none : .checkmark
        }else{
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ??  1
    }
    
    //MARK: - Tableview delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])

        if let item = todoItems?[indexPath.row]{
            print("Selected Item \(item.title)")
            do{
                try realm.write {
                    //delete item
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Update item fail \(error)")
            }
        }
        //todoItems[indexPath.row].done = !todoItems[indexPath.row]?.done
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        //saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add Item Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Successful")
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Unable to save Item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            print("New TextField")
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            print("Complete")
        }
        
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let currenyItem = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(currenyItem)
                }
            }catch{
                print("Delete Category Error \(error)")
            }
            tableView.reloadData()
        }
    }

}

//MARK: - Search bar functions
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        /*let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        tableView.reloadData()*/
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

