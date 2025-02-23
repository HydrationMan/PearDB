//
//  firmwareView.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

struct FirmwareView: View {
    @State private var firmwares: [Firmware] = []
    @State private var isLoading = true
    @ObservedObject private var downloader = AppleDBDownloader.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if downloader.isDownloading {
                    ProgressView("Downloading Firmware Data…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List(firmwares) { firmware in
                        NavigationLink(destination: FirmwareDetailView(firmware: firmware)) {
                            VStack(alignment: .leading) {
                                Text(firmware.osStr)
                                    .font(.headline)
                                Text(firmware.version)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .navigationTitle("Firmwares")
                }
            }
            .onAppear {
                Task {
                    do {
                        try await downloader.downloadAllIfNeeded()
                    } catch {
                        print("❌ Error downloading firmwares: \(error)")
                    }
                    loadFirmwareData()
                }
            }
        }
    }
    
    private func loadFirmwareData() {
        DispatchQueue.global(qos: .background).async {
            Task { // Start a new task to switch to the correct actor context
                if let data = await downloader.loadLocalJSON(named: "ios_main") { // Use `await` since it's actor-isolated
                    do {
                        let decodedFirmwares = try JSONDecoder().decode([Firmware].self, from: data)
                        DispatchQueue.main.async {
                            self.firmwares = decodedFirmwares
                            self.isLoading = false
                        }
                    } catch {
                        print("❌ Error decoding firmwares: \(error)")
                    }
                } else {
                    print("⚠️ No local firmware data found.")
                }
            }
        }
    }
}

struct FirmwareDetailView: View {
    let firmware: Firmware
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(firmware.osStr)
                .font(.largeTitle)
                .bold()
            Text("Version: \(firmware.version)")
                .font(.title2)
            if let released = firmware.released, !released.isEmpty {
                Text("Released: \(released)")
                    .foregroundColor(.secondary)
            }
            
            if !firmware.deviceMap.isEmpty {
                Text("Compatible Devices:")
                    .font(.headline)
                    .padding(.top, 5)
                List(firmware.deviceMap, id: \.self) { device in
                    Text(device)
                }
            }
            
            Link("View online at AppleDB", destination: URL(string: firmware.appledburl)!)
                .font(.headline)
                .padding(.top, 10)
            Spacer()
        }
        .padding()
        .navigationTitle("\(firmware.osStr) \(firmware.version) (\(firmware.build ?? ""))")
    }
}

struct Firmware: Identifiable, Codable {
    var id = UUID()
    let osStr: String
    let version: String
    let build: String?
    let key: String
    let released: String?
    let appledburl: String
    let deviceMap: [String]

    private enum CodingKeys: String, CodingKey {
        case osStr, version, build, key, released, appledburl, deviceMap
    }
}

class FirmwareAPI {
    @MainActor static func fetchLocalFirmwareList() -> [Firmware] {
        if let data = AppleDBDownloader.shared.loadLocalJSON(named: "ios_main") {
            do {
                return try JSONDecoder().decode([Firmware].self, from: data)
            } catch {
                print("❌ Error decoding firmwares: \(error)")
            }
        }
        return []
    }
}

