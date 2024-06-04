//
//  ContentView.swift
//  PearDB TV
//
//  Created by Kane Parkinson on 25/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HelloView()
            }
            NavigationStack {
                TestView()
            }
            NavigationStack {
                SettingsView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
