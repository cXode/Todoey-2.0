//
//  CategoryTableViewController.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 19/09/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryItemArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        
        cell?.textLabel?.text = categoryItemArray[indexPath.row].name
        let item = categoryItemArray[indexPath.row]
        return cell!
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let categoryAlert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let categoryDeleteAction = UIAlertAction(title: "Delete", style: .default) { (categoryDeleteAction) in
            categoryAlert.dismiss(animated: true, completion: nil)
        }
        let categoryAddItemAction = UIAlertAction(title: "OK", style: .default) { (categoryAddItemAction) in
            
            if categoryTextField.text != "" {
                let newItem = Category(context: self.context)
                newItem.name = categoryTextField.text!
                self.categoryItemArray.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
            else {
                let newAlert = UIAlertController(title: "You must write something!", message: "", preferredStyle: .alert)
                let newAction = UIAlertAction(title: "OK", style: .default, handler: { (newAction) in })
                newAlert.addAction(newAction)
                self.present(newAlert, animated: true, completion: nil)
            }
        }
            categoryAlert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Type new category here"
                categoryTextField = alertTextField
            }
            categoryAlert.addAction(categoryDeleteAction)
            categoryAlert.addAction(categoryAddItemAction)
            
            present(categoryAlert, animated: true, completion: nil)
        
        
        
    }
    
    func saveItems() {
        do {
            try context.save()
        }
        catch{
        print("Error is \(error)")
        }
    }
    
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            try context.fetch(request)
            
        }
        catch {
            print("Error is \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryItemArray[indexPath.row]
        }
    }
}

extension CategoryTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS %@[cd]", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(with:request)
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
