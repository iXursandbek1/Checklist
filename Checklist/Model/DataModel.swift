//
//  DataModel.swift
//  Checklist
//
//  Created by Xursandbek Qambaraliyev on 29/03/23.
//

import Foundation
class DataModel {
    
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults() {
      let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        
      UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    } set {
        UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")}
    }
    
    func handleFirstTime() {
      let userDefaults = UserDefaults.standard
      let firstTime = userDefaults.bool(forKey: "FirstTime")
      if firstTime {
        let checklist = Checklist(name: "List")
        lists.append(checklist)
        indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
      }
    }
    
    func sortChecklists() {
      lists.sort { list1, list2 in
        return list1.name.localizedStandardCompare(list2.name) == .orderedAscending }
    }
    
    // MARK: - Data Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        
        return documentsDirectory().appendingPathComponent("Checklists.plist")

    }

    // this method is now called saveChecklists()
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            // You encode lists instead of "items"
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
            }
        }
        // this method is now called loadChecklists()
    func loadChecklists() {
        
            let path = dataFilePath()
            if let data = try? Data(contentsOf: path) {
              let decoder = PropertyListDecoder()
              do {
                  // You decode to an object of [Checklist] type to lists
                  lists = try decoder.decode([Checklist].self, from: data)
                  sortChecklists()
              } catch {
                print("Error decoding list array: \(error.localizedDescription)")
          }
                
        }
    }
}