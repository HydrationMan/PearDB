//
//  DeviceEntry.swift
//  PearDB
//
//  Created by Kane Parkinson on 06/02/2025.
//

import Foundation
import CoreData

final class Entry: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var key: String?
    @NSManaged var isMain: Bool
    @NSManaged var firmware: String?
    @NSManaged var serial: String?
    @NSManaged var preferredIcon: String?
    @NSManaged var type: String?
    @NSManaged var version: String?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(false, forKey: "isMain")
    }
    
}

extension Entry {
    private static var entryFetchRequest: NSFetchRequest<Entry> {
        NSFetchRequest(entityName: "Entry")
    }
    
    static func all() -> NSFetchRequest<Entry> {
        let request: NSFetchRequest<Entry> = entryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Entry.key, ascending: true)
        ]
        return request
    }
}
