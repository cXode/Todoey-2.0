//
//  ViewController.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 08/08/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    // MARK: - 3.1 Neka itemArray bude array objekata iz Item classa
    var itemArray = [Item]()

    
    
    //MARK: - 2.1 Inicijaliziran userDefaults
    var defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        let newItem = Item()
        
    }
    
    
    //MARK: - 1.1 Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")
        //MARK: - 3.2 Celije popunjavamo sa title propertie Item classa
        cell?.textLabel?.text = itemArray[indexPath.row].title
        
        //MARK: - 3.3 Skracujemo itemArray[indexPath.row] u item
        let item = itemArray[indexPath.row]
        
        //MARK: - 3.4.1 Odlucujemo koja celija ce imate kvacicu a koja ne
        
//        if item.done == true {
//            cell?.accessoryType = .checkmark
//        }
//        else{
//            cell?.accessoryType = .none
//        }
        
        //MARK: - 3.4.2 Kod iz 3.4.1 skracujemo u ternary oblik
        // value = condition ? valueIfTrue : ValueIfFalse
        
        cell?.accessoryType = item.done == true ? .checkmark : .none
        
        return cell!
        
    }
    //MARK: - 1.2 Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //MARK: - 3.5 Svaki put kad kliknemo na celiju "Done" propertie iz Item classa postaje suprotan onome sto je bio
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        //MARK: - 3.6 Reloadamo data u tableviewu jer inace nema nikakve promjene zato sto je bez reloadanje prizvano samo pri paljenju aplikacije, a ovako ce biti reloadano svakim klikom
        tableView.reloadData()
        
        //MARK: - 1.3 UX poboljšanje: kliknuta ćelija na tren potamni
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - 1.5 Dodan gumb za dodavanje itema
    
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if textField.text != "" {
                //MARK: - 3.7 Appendamo svaki Item u itemArray i sada userdefaults postaje prenapucen sa svim podatcima koje bi morao spremiti u svoj plist i zbog toga tu stajemo i krecemo raditi sa NSCoderom
                let newItem = Item()
                newItem.title = textField.text
                
                
                
                self.itemArray.append(newItem)
                
                //MARK: - 2.2 Spremljen svaki novi dodani item u userDefaults.plist
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
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









