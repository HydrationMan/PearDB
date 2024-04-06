//
//  DeviceScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct DeviceScreen: View {
    var body: some View {
        NavigationView {
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
                List {
                    Text("Beans")
                }
                
                .scrollContentBackground(.hidden)
                    .navigationTitle("Epic")
                    .toolbar {
                        ToolbarItem {
                            Image(systemName: "plus")
                        }
                    }
            }
        }
    }
}
