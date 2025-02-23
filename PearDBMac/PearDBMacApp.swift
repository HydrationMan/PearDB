//
//  PearDBMacApp.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

@main
struct PearDBMacApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, DeviceEntryProvider.shared.viewContext)
        }
    }
}

// MARK: NavigationSplitView
struct MainView: View {
    @State private var selected: Int? = 0

    var body: some View {
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
                            Label("Database", systemImage: "tray.full")
                        }
                        NavigationLink(value: 3) {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                } header: {
                    Text("PearDB")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("PearDB")
            .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
        } detail: {
            if let selected = selected {
                switch selected {
                case 0:
                    DeviceSectionView()
                case 1:
                    Text("Firmware - soon")
                case 2:
                    Text("Database - soon")
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
}

// Toggle Sidebar Function
func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
