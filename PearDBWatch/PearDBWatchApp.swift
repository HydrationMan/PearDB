//
//  PearDBWatchApp.swift
//  PearDBWatch
//
//  Created by Kane Parkinson on 04/02/2025.
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
