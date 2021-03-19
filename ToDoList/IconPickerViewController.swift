//
//  IconPickerViewController.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 10/7/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

protocol IconPickerVCDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    weak var delegate: IconPickerVCDelegate?

    let icons = ["Actvities", "Appointments", "Birthdays", "Chores", "Documents", "Drinks", "Favorites", "Folder", "Liked",
                 "Music", "No Icon", "Photos", "Shopping", "Smile", "Trips" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        cell.textLabel!.text = icons[indexPath.row]
        cell.imageView!.image = UIImage(named: icons[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(self, didPick: icons[indexPath.row])
    }

}
