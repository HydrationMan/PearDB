//
//  ContentView.swift
//  PearDB
//
//  Created by Kane Parkinson on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                AppleDBView()
            }            
            .tabItem {
                Image(systemName: "pc")
                Text("AppleDB")
            }
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.2.fill")
                Text("Settings")
            }
        }
    }
}
