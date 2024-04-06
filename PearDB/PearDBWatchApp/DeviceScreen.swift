//
//  DeviceScreen.swift
//  PearDBWatchApp
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI

struct DeviceScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                Text("Buy Rune!")
                AsyncImage(url: URL(string: "https://img.appledb.dev/device@main/iPhone16,1/0.avif")) { phase in
                    if let image = phase.image {
                        image
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.triangle").padding()
                    } else {
                        Text("Loading")
                    }}
            }
        }
    }
}
