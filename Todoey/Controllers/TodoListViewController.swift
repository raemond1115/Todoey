//
//  ViewController.swift
//  Todoey
//
//  Created by Lung Wa Li on 3/19/18.
//  Copyright © 2018 Lung Wa Li. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //var itemArray = ["Study iOS", "Study AWS", "Teach Celia", "Play with Norton"]

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }*/
        let newItem = Item()
        newItem.title = "Study iOS"
        
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Study AWS"
        
        itemArray.append(newItem1)
        let newItem2 = Item()
        newItem2.title = "Study Machine Learning"
        
        itemArray.append(newItem2)
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = !itemArray[indexPath.row].done ? .none : .checkmark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        /*let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }*/
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add Item Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Successful")
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
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
    
    

}

