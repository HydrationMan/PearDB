//
//  DeviceEntryProvider.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import Foundation
import CoreData

final class DeviceEntryProvider {
    static let shared = DeviceEntryProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init(){
        
        persistentContainer = NSPersistentContainer(name: "DeviceDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores {_, error in
            if let error {
                fatalError("❌ Unable to load store with error: \(error)")
            }
        }
    }
}
