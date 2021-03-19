//
//  ChecklistViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 8/26/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var groupItem: GroupItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        title = groupItem.name
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = groupItem.tasks[indexPath.row]
            }
        }
    }
    
    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupItem.tasks.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        
        let item = groupItem.tasks[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }

    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = groupItem.tasks[indexPath.row]
            item.toggleChecked()
                
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        // GrouptTableVC.saveGroups()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        groupItem.tasks.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // GrouptTableVC.saveGroups()
    }
    
    // MARK: - Helping method
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.alpha = 1
        } else {
            label.alpha = 0
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - AddItemVC Delegate
    
    func addItemVCDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemVC(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = groupItem.tasks.count
        groupItem.tasks.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
        // GrouptTableVC.saveGroups()
    }
    
    func addItemVC(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        if let index = groupItem.tasks.firstIndex(of: item) {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        // GrouptTableVC.saveGroups() -> Child -> Parent
        // delegate?.didFinishAddingTask
    }
    
}
