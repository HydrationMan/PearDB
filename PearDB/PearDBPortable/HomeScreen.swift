//
//  HomeScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct HomeScreen: View {
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
                Text("PearDB!")
                AsyncImage(url: URL(string: "https://img.appledb.dev/device@main/iPhone16,1/0.avif")) { phase in
                    if let image = phase.image {
                        image
                    } else if phase.error != nil {
                        Image(systemName: "exclamationmark.triangle").padding()
                    } else {
                        ProgressView()
                        Text("Loading...")
                    }}
            }
        }
    }
}
