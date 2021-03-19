//
//  AddGroupViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 9/23/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

protocol AddGroupVCDelegate: class {
    func addGroupVCDidCancel(_ controller: AddGroupViewController)
    
    func addGroupVC(_ controller: AddGroupViewController, didFinishAdding group: GroupItem)
    
    func addGroupVC(_ controller: AddGroupViewController, didFinishEditing group: GroupItem)
}

class AddGroupViewController: UITableViewController, IconPickerVCDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: AddGroupVCDelegate?
    var groupItemToEdit: GroupItem? = nil
    var iconName = "No Icon"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = groupItemToEdit {
            title = "Edit Group"
            textField.text = item.name
            doneBarButton.isEnabled = true
            iconImageView.image = UIImage(named: item.iconName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickIcon" {
            let destination = segue.destination as! IconPickerViewController
            
            destination.delegate = self
        }
    }
    
    @IBAction func cancel() {
        delegate?.addGroupVCDidCancel(self)
    }
    
    @IBAction func done() {
        if let group = groupItemToEdit {
            group.name = textField.text!
            group.iconName = iconName
            delegate?.addGroupVC(self, didFinishEditing: group)
        } else {
            let groupItem = GroupItem(name: textField.text!) // creating object groupItem
            groupItem.iconName = iconName
            delegate?.addGroupVC(self, didFinishAdding: groupItem) // sending groupItem to delegate
        }
        
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        doneBarButton.isEnabled = textField.text == "" ? false : true
    }
    
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
}

/*
 HW:
 1. UITableViewController
 2.  add to NavigationController
 3. + -> add Name
 4. Model = Class Student(name: age:)
 5. list = [Student(Aslan, 18), Student(Atai, 19), ....] + -> Student(Asol, 20) (UITableViewController)
 6. numberOfRowsInSection -> list.count , cellForRowAt add Tag to labels
 7. swipeToDelete
*/
