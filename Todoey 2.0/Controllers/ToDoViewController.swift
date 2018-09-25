//
//  ViewController.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 08/08/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
   
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //MARK: - 5.1 stvaramo context za Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")
   
        cell?.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell?.accessoryType = item.done == true ? .checkmark : .none
        return cell!
        
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (deleteAction) in
        alert.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           
            if textField.text != "" {
                
                //MARK: - 5.2
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
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
   
    func saveItems() {
 
    do{
        try context.save()
    }
    catch {
    print(error)
    }
    }
    
    
    

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        request.predicate = categoryPredicate
        do {
        try context.fetch(request)
        }
        catch{
            print(error)
        }
    }
}




extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        
        let predicate = NSPredicate(format: "title CONTAINS %@[cd]", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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






