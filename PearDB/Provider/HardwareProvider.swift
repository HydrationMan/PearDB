//
//  HardwareProvider.swift
//  PearDB
//
//  Created by Kane Parkinson on 31/07/2024.
//

import Foundation
import CoreData

final class HardwareProvider {
    static let shared = HardwareProvider()
    
    private let persistentCloudKitContainer: NSPersistentCloudKitContainer
    
    var viewContext: NSManagedObjectContext {
        persistentCloudKitContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentCloudKitContainer.persistentStoreCoordinator
        return context
    }
    
    private init() {
        persistentCloudKitContainer = NSPersistentCloudKitContainer(name: "HardwareDataModel")
        guard let description = persistentCloudKitContainer.persistentStoreDescriptions.first else {
            fatalError("Failed to initialize persistent container")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.hydrate.PearDB.Hardware")
        
        
        persistentCloudKitContainer.persistentStoreDescriptions = [ description ]
        persistentCloudKitContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentCloudKitContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentCloudKitContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error.localizedDescription)")
            }
        }
    }
}
