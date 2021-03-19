//
//  DataModel.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 10/3/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import Foundation



class DataModel {
    
    var groupItems = [GroupItem]()
    
    var indexOfLastGroup: Int {
        get {
            return UserDefaults.standard.integer(forKey: "GroupIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "GroupIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadGroups()
        registerUserDefaults()
    }
    
    // MARK: - Data Saving
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("GroupList.plist")
    }
    
    func saveGroups() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(groupItems)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadGroups() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            let decoder = PropertyListDecoder()
            
            do {
                groupItems = try decoder.decode([GroupItem].self, from: data)
                sortGroups()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerUserDefaults() {
        let dictionary = ["GroupIndex" : -1]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func sortGroups() {
        groupItems.sort { (group1, group2) -> Bool in
            group1.name.localizedStandardCompare(group2.name) == .orderedAscending
        }
    }
    
    static func nextTaskID() -> Int {
        let userDefaults = UserDefaults.standard
        
        let taskID = userDefaults.integer(forKey: "TaskID")
        userDefaults.setValue(taskID + 1, forKey: "TaskID")
        userDefaults.synchronize()
        
        return taskID
    }
    
}
