//
//  GroupTableViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 9/18/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController, AddGroupVCDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "GroupCell"
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfLastGroup
        
        if index >= 0 && index < dataModel.groupItems.count {
            let groupItem = dataModel.groupItems[index]
            performSegue(withIdentifier: "showGroup", sender: groupItem)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroup" {
            let destinationController = segue.destination as! ChecklistViewController
            destinationController.groupItem = sender as? GroupItem
            
        } else if segue.identifier == "addGroup" {
            let destinationController = segue.destination as! AddGroupViewController
            destinationController.delegate = self
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfLastGroup = -1
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.groupItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier ) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let group = dataModel.groupItems[indexPath.row]
        let count = group.countUncheckedTasks()
        
        cell.textLabel!.text = group.name
        cell.accessoryType = .detailDisclosureButton
        
        if group.tasks.count == 0 {
            cell.detailTextLabel!.text = "Empty"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All done!" : "\(count) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: group.iconName)
    
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfLastGroup = indexPath.row
        
        let groupItem = dataModel.groupItems[indexPath.row]
        performSegue(withIdentifier: "showGroup", sender: groupItem)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddGroupController") as! AddGroupViewController
        controller.delegate = self
        controller.groupItemToEdit = dataModel.groupItems[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.groupItems.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Add GroupVC Delegate
    
    func addGroupVCDidCancel(_ controller: AddGroupViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addGroupVC(_ controller: AddGroupViewController, didFinishAdding group: GroupItem) {
      
        dataModel.groupItems.append(group)
        dataModel.sortGroups()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func addGroupVC(_ controller: AddGroupViewController, didFinishEditing group: GroupItem) {
        
        dataModel.sortGroups()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
}
