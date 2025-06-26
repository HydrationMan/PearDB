//
//  SettingsView.swift
//  PearDB
//
//  Created by Kane Parkinson on 09/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var isPurging = false
    @State private var isRedownloading = false
    var body: some View {
        Form {
            Section(header: Text("Debug")) {
                Button("Purge Downloaded Data") {
                    isPurging = true
                }
                .foregroundColor(.red)
                .alert(isPresented: $isPurging) {
                    Alert(
                        title: Text("Purge Downloaded Data"),
                        message: Text("Are you sure? This will delete all local jsons and trigger a redownload on subsequent view access!"),
                        primaryButton: .destructive(Text("Purge")) {
                            purgeData()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func purgeData() {
        isPurging = true
        Task {
            do {
                try await AppleDBDownloader.shared.purgeData()
                print("✅Data purged successfully")
            } catch {
                print("❌ Error purging data: \(error)")
            }
            isPurging = false
        }
    }

    private func redownloadData() {
        isRedownloading = true
        Task {
            do {
                try await AppleDBDownloader.shared.downloadAllIfNeeded()
                print("✅Data redownloaded successfully")
            } catch {
                print("❌ Error redownloading data: \(error)")
            }
            isRedownloading = false
        }
    }
}
