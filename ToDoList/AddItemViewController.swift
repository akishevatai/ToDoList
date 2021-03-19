//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 9/2/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//



import UIKit
import UserNotifications
protocol AddItemViewControllerDelegate: class {
    func addItemVCDidCancel(_ controller: AddItemViewController)
    
    func addItemVC(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    
    func addItemVC(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    weak var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    //MARK: - Helper methods
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueDateLabel.text = formatter.string(from: dueDate)
        
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let datePickerIndex = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [datePickerIndex], with: .fade)
        
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
        
            let datePickerIndex = IndexPath(row: 2, section: 1)
            
            tableView.deleteRows(at: [datePickerIndex], with: .fade)
        }
    }
    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        delegate?.addItemVCDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.createNotification()
            
            delegate?.addItemVC(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.createNotification()
            
            delegate?.addItemVC(self, didFinishAdding: item)
        }
        
    }
    
    @IBAction func texfieldDidChange(_ sender: UITextField) {
        if textField.text == "" {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
        
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    print("User granted a permission to send notifications")
                }
            }
        }
    }
   
    
    //MARK: - Tabel View Delegate and Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible == true {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if datePickerVisible == false {
                showDatePicker()
            } else {
            hideDatePicker()
            }
        }
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndex = indexPath
        
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndex = IndexPath(row: 0, section: indexPath.section)
        } else {
            
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndex)

    }

}
