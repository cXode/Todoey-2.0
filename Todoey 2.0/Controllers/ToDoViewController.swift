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
    //MARK: - 4.1 Krecemo raditi s NSCoderom, stvaramo singleton dataFilePath
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        print("hello")
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
    
        //MARK: - 4.3.2 prizivamo funkciju da enkodira done u Items.plist
        self.saveItems()
        
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
                newItem.title = textField.text!
                
                
                
                self.itemArray.append(newItem)
                
                //MARK: - 4.3.1 prizivamo funkciju da enkodira title u Items.plist
                self.saveItems()
                
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
    
    //MARK: - 4.2 Stvaramo funkciju koja ce enkodirati nas Item class i njegove propertie u Items.plist
    func saveItems() {
    let encoder = PropertyListEncoder()
    
    do{
    let data = try encoder.encode(itemArray)
    try data.write(to: dataFilePath!)
    }
    catch {
    print(error)
    }
    }
    
    //MARK: - 4.4 Stvaramo funkciju koja ce dekodirati nas plist i prikazati ga u celijama
    func loadItems() {
    
        if let data = try? Data(contentsOf: self.dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print(error)
            }
            
            }
        
    
    }
}









