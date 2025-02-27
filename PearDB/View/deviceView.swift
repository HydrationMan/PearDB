//
//  ContentView.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI
import OSLog

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
                        NavigationLink(destination: DeviceDetailView(device: device)) {
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
            .onAppear {
                Task {
                    do {
                        try await downloader.downloadAllIfNeeded()
                    } catch {
                        print("❌ Error downloading device data: \(error)")
                    }
                    loadDeviceData()
                }
            }
        }
    }
    
    private func loadDeviceData() {
        DispatchQueue.global(qos: .background).async {
            Task {
                if let data = await downloader.loadLocalJSON(named: "device_main") {
                    do {
                        let decodedDevices = try JSONDecoder().decode([Device].self, from: data)
                        DispatchQueue.main.async {
                            self.devices = decodedDevices
                            self.isLoading = false
                        }
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
    }
}

struct DeviceDetailView: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(device.name)
                .font(.largeTitle)
                .bold()
            if let type = device.type {
                Text("Type: \(type)")
                    .font(.title2)
            }
            if let released = device.released {
                Text("Released: \(released)")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(device.name)
        .onAppear() {
            let peardbLogger = Logger.init(
                subsystem: "com.hydrate.PearDB.device", category: "com.hydrate.PearDB.debug"
            )
            peardbLogger.log(level: .error,"""
            📝 Device: \(device.name)
                ↳ IDENTIFIER: \(device.identifier ?? "⚠️ N/A")
                ↳ SOC: \(device.soc ?? "⚠️ N/A")
                ↳ CPID: \(device.cpid ?? "⚠️ N/A")
                ↳ ARCH: \(device.arch ?? "⚠️ N/A")
                ↳ TYPE: \(device.type ?? "⚠️ N/A")
                ↳ BOARD: \(device.board ?? ["⚠️ N/A"])
                ↳ BDID: \(device.bdid ?? "⚠️ N/A")
                ↳ MODEL: \(device.model ?? ["⚠️ N/A"])
                ↳ INFO: \(device.info?.map { "\($0.type) (\($0.storage ?? "⚠️ N/A") Storage, \($0.ram ?? "⚠️ N/A") RAM)" }.joined(separator: ", ") ?? "⚠️ N/A")
                ↳ KEY: \(device.key)
                ↳ RELEASED: \(device.released ?? "⚠️ N/A")
            """)
        }
    }
}

