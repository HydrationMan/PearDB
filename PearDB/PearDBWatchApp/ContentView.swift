//
//  ContentView.swift
//  PDB Watch App
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                TabView() {
                    HomeScreen()
                    DeviceScreen()
                    SettingsScreen()
                }
                .tabViewStyle(.verticalPage)
            }
        }
    }
}
