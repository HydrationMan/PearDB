//
//  ContentView.swift
//  PDB Watch App
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI


extension Color {
    static let PearCyan = Color("PearCyan")
}

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                TabView() {
                    HomeScreen()
                    DeviceScreen()
                    SettingsScreen()
                    SoundScreen()
                }
            }
            .tabViewStyle(.carousel)
        }
        .compositingGroup()
    }
}

