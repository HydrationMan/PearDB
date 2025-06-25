//
//  editDeviceViewModel.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import Foundation
import CoreData


final class editDeviceViewModel: ObservableObject {
    
    @Published var entry: Entry
    
    private let context: NSManagedObjectContext
    
    init(provider: DeviceEntryProvider, device: Entry? = nil) {
        self.context = provider.newContext
        self.entry = Entry(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
}
