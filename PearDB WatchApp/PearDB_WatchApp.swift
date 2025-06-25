//
//  PearDB_WatchApp.swift
//  PearDB WatchApp
//
//  Created by Kane Parkinson on 24/06/2025.
//

import SwiftUI

@main
struct PearDBWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DeviceEntryProvider.shared.viewContext)
        }
    }
}
