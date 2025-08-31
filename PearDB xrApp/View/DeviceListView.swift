//
//  DeviceListView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct DeviceListView: View {
    @State private var devices: [Device] = []
    @State private var isLoading = true
    @ObservedObject private var downloader = AppleDBDownloader.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if downloader.isDownloading {
                    ProgressView("Downloading Device Data…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List(devices) { device in
                        NavigationLink(destination: DeviceDetailView(device: device, fromDB: false)) {
                            VStack(alignment: .leading) {
                                Text(device.name)
                                    .font(.headline)
                                if let type = device.type {
                                    Text(type)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .navigationTitle("Devices")
                }
            }
            .task {
                do {
                    try await downloader.downloadAllIfNeeded()
                } catch {
                    print("❌ Error downloading device data: \(error)")
                }
                loadDeviceData()
            }
        }
    }
    
    @MainActor
    private func loadDeviceData() {
        if let data = downloader.loadLocalJSON(named: "device_main") {
            do {
                let decodedDevices = try PJSONDecoder().decode([Device].self, from: data)
                self.devices = decodedDevices
                self.isLoading = false
            } catch let DecodingError.typeMismatch(_, context) {
                print("❌ Type mismatch error: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")

                // Attempt to print the offending JSON section
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonArray = jsonObject as? [[String: Any]] {

                    // Print the specific object at the reported index
                    if let index = context.codingPath.first?.intValue, index < jsonArray.count {
                        print("❌ Offending JSON entry: \(jsonArray[index])")
                    }
                }
            } catch {
                print("❌ Error decoding devices: \(error)")
            }
        } else {
            print("⚠️ No local device data found.")
        }
    }
}
