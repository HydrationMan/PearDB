//
//  ContentView.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 18/01/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                TabView() {
                    HomeScreen()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    DeviceScreen()
                        .tabItem {
                            Label("Devices", systemImage: "archivebox")
                        }
                    SettingsScreen()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
            }
        }
    }
}
