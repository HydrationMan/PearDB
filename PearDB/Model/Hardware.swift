//
//  Hardware.swift
//  PearDB
//
//  Created by Kane Parkinson on 31/07/2024.
//

import Foundation
import CoreData

final class Hardware: NSManagedObject, Identifiable {
    @NSManaged var note: String
    @NSManaged var chip: String
    @NSManaged var identifier: String
    @NSManaged var build: String
    @NSManaged var device: String
    @NSManaged var version: String
    @NSManaged var nickname: String
    @NSManaged var serialnum: String
    @NSManaged var buildBeta: Bool
    @NSManaged var buildFinal: Bool
    @NSManaged var buildUpdateLatest: Bool
    @NSManaged var buildUpdateAvailable: Bool
    @NSManaged var buildInternal: Bool
    @NSManaged var osStr: String
    @NSManaged var buildRC: Bool
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(false, forKey: "buildInternal")
        setPrimitiveValue(false, forKey: "buildBeta")
        setPrimitiveValue(false, forKey: "buildFinal")
        setPrimitiveValue(false, forKey: "buildUpdateLatest")
        setPrimitiveValue(false, forKey: "buildUpdateAvailable")
        setPrimitiveValue(false, forKey: "buildRC")
    }
}

extension Hardware {
    private static var hardwareFetchRequest: NSFetchRequest<Hardware> {
        NSFetchRequest(entityName: "Hardware")
    }
    static func all() -> NSFetchRequest<Hardware> {
        let request: NSFetchRequest<Hardware> = hardwareFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Hardware.identifier, ascending: true)
        ]
        return request
    }
    
    static func empty(context: NSManagedObjectContext = HardwareProvider.shared.viewContext) -> Hardware {
        return Hardware(context: context)
    }
}
                            
