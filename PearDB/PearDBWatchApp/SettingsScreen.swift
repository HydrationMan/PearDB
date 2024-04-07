//
//  SettingsScreen.swift
//  PearDBWatchApp
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .fixedCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Buy Rune!, this is the settings page")
            }
        }
    }
}
