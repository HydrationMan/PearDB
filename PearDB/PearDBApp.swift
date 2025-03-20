//
//  PearDBApp.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

@main
struct PearDBApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, DeviceEntryProvider.shared.viewContext)
        }
    }
}

// MARK: Tab View
struct MainView: View {
    @StateObject var deviceViewModel: DeviceViewModel = .init()
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    @StateObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init()
    
    var body: some View {
        TabView {
            DeviceView()
                .tabItem {
                    Label("Devices", systemImage: "internaldrive")
                }
            FirmwareView()
                .tabItem {
                    Label("Firmware", systemImage: "terminal")
                }
            DatabaseView()
                .tabItem {
                    Label("Database", systemImage: "tray.full")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(deviceViewModel)
        .environmentObject(dbViewModel)
        .environmentObject(deviceFirmwaresViewModel)
    }
}
