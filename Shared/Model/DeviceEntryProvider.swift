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
    
    private let persistentContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init(){
        persistentContainer = NSPersistentCloudKitContainer(name: "DeviceDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        if let description = persistentContainer.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        persistentContainer.loadPersistentStores {description, error in
            if let error, let url = description.url {
                let coordinator = self.persistentContainer.persistentStoreCoordinator
                // Destroy
                try? coordinator.destroyPersistentStore(at: url, type: .sqlite)
                // Re-create
                _ =  try? coordinator.addPersistentStore(type: .sqlite, at: url)
                print(error.localizedDescription)
            }
        }
    }
    
    private func purgeCoreData() {
        let coordinator = self.persistentContainer.persistentStoreCoordinator
                
        coordinator.persistentStores.compactMap { $0.url }.forEach {
            try? coordinator.destroyPersistentStore(at: $0, type: .sqlite)
        }
    }
}
