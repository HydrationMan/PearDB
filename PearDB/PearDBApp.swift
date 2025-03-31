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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selected: Int? = 0
    @StateObject var deviceViewModel: DeviceViewModel = .init()
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    @StateObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init()
    @StateObject var firmwaresViewModel: FirmwaresViewModel = .init()
    
    var body: some View {
        if horizontalSizeClass == .regular {
            NavigationSplitView {
                List(selection: $selected) {
                    Section {
                        Group {
                            NavigationLink(value: 0) {
                                Label("Devices", systemImage: "internaldrive")
                            }
                            NavigationLink(value: 1) {
                                Label("Firmware", systemImage: "terminal")
                            }
                            NavigationLink(value: 2) {
                                Label("My Devices", systemImage: "tray.full")
                            }
                            NavigationLink(value: 3) {
                                Label("Settings", systemImage: "gear")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: Alignment.leading)
                    } header: {
                        Text("PearDB")
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("PearDB")
            } detail: {
                VStack {
                    if let selected = selected {
                        switch selected {
                        case 0:
                            DeviceSectionView()
                                .environmentObject(deviceViewModel)
                                .environmentObject(dbViewModel)
                                .environmentObject(deviceFirmwaresViewModel)
                        case 1:
                            FirmwareView()
                                .environmentObject(deviceViewModel)
                                .environmentObject(dbViewModel)
                                .environmentObject(deviceFirmwaresViewModel)
                                .environmentObject(firmwaresViewModel)
                        case 2:
                            DatabaseView()
                                .environmentObject(deviceViewModel)
                                .environmentObject(dbViewModel)
                                .environmentObject(deviceFirmwaresViewModel)
                        case 3:
                            Text("Settings - soon")
                        default:
                            Text("Select an option from the sidebar")
                        }
                    } else {
                        Text("Select an option from the sidebar")
                    }
                }
            }
            .onAppear {
                self.selected = 0
            }
        }
        else {
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
            .environmentObject(firmwaresViewModel)
        }
    }
}
