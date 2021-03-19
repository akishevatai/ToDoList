//
//  GroupItem.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 9/18/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation

class GroupItem: NSObject, Codable {
    var name: String
    var tasks: [ChecklistItem] = []
    var iconName = "Actvities"
    
    init(name: String) {
        self.name = name
    }
    
    func countUncheckedTasks() -> Int {
        var count = 0
        
        for task in tasks {
            if task.checked == false {
                count += 1
            }
        }
        
        return count
    }
    
}

// ChecklistItem, ChecklistItem, ChecklistItem
