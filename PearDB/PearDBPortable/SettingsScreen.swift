//
//  SettingsScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                Color.clear
                    .frame(height: 5)
                    .background(Material.bar)
            }
            VStack {
                Text("More Testing text, some settings here probably")
            }
        }
    }
}
