//
//  ViewController.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 08/08/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    var itemArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - 1. Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")
        
        cell?.textLabel?.text = itemArray[indexPath.row]
        
        return cell!
        
    }
    //MARK: - 2. Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //MARK: - 4. Dodajemo/Mičemo Checkmark kad god kliknemo na ćelij
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //MARK: - 3. UX poboljšanje: kliknuta ćelija na tren potamni
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - 5. Dodan gumb za dodavanje itema
    
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if textField.text != "" {
                self.itemArray.append(textField.text!)
                self.tableView.reloadData()
            }
            else {
                let alert = UIAlertController(title: "You must write something", message: "", preferredStyle: .alert )
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type your item here"
            textField = alertTextField
            
        }
        alert.addAction(deleteAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}









