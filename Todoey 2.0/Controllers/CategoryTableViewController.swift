//
//  CategoryTableViewController.swift
//  Todoey 2.0
//
//  Created by Antonio Markotic on 19/09/2018.
//  Copyright © 2018 Antonio Markotic. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        
        cell?.textLabel?.text = categories?[indexPath.row].name ?? "No Categorie Added Jet"
        return cell!
    }
    
    
   
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let categoryAlert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let categoryDeleteAction = UIAlertAction(title: "Delete", style: .default) { (categoryDeleteAction) in
            categoryAlert.dismiss(animated: true, completion: nil)
        }
        let categoryAddItemAction = UIAlertAction(title: "OK", style: .default) { (categoryAddItemAction) in
            
            if categoryTextField.text != "" {
                let newCategory = Category()
                newCategory.name = categoryTextField.text!
                
                
                self.save(category: newCategory)
              
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
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
        print("Error is \(error)")
        }
    }
    

    func loadCategories() {
       categories = realm.objects(Category.self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

extension CategoryTableViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("title CONTAINS[cd] %@",  searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            //loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
