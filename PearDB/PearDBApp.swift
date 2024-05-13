//
//  PearDBApp.swift
//  PearDB
//
//  Created by Kane Parkinson on 06/05/2024.
//

import SwiftUI

@main
struct PearDBApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
