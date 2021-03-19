//
//  ChecklistItem.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 8/28/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text: String
    var checked: Bool
    var shouldRemind = false
    var dueDate = Date()
    var itemID = -1
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextTaskID()
    }
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked.toggle()
    }
    
    func createNotification() {
        removeNotification()
        if shouldRemind  && dueDate > Date() {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = .default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            center.add(request)
            
            print("New notification added for item: \(itemID)")
        }
    }
        func removeNotification() {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
        }
        
    }


