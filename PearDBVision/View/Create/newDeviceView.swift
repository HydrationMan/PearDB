//
//  newDeviceView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct newDeviceView: View {
    
    @State private var searchText = ""
    @State private var devices: [Device] = []
    @State private var filteredDevices: [Device] = []
    @State private var selectedDevice: Device?
    @ObservedObject private var downloader = AppleDBDownloader.shared
    @ObservedObject var vm: editDeviceViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a device", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { filterDevices() }

                List(filteredDevices, id: \.key) { device in
                    Button(action: {
                        selectedDevice = device
                    }) {
                        Text(device.name)
                    }
                }

                if let selected = selectedDevice {
                    newDeviceDetailView(device: selected)
                }
            }
            .navigationTitle("Device Search")
            .onAppear(perform: loadDeviceData)
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
                            self.filteredDevices = decodedDevices
                        }
                    } catch let DecodingError.typeMismatch(_, context) {
                        print("❌ Type mismatch error: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")

                        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                           let jsonArray = jsonObject as? [[String: Any]] {
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

    private func filterDevices() {
        filteredDevices = searchText.isEmpty
            ? devices
            : devices.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

struct newDeviceDetailView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading) {
            Text("Device Name: \(device.name)")
                .font(.headline)
            if let identifier = device.identifier?.joined(separator: ", ") {
                Text("Identifier: \(identifier)")
            }
            if let board = device.board?.joined(separator: ", ") {
                Text("Board: \(board)")
            }
            if let model = device.model?.joined(separator: ", ") {
                Text("Model: \(model)")
            }
            if let released = device.released {
                Text("Released: \(released)")
            }
        }
        .padding()
    }
}
#Preview {
    NavigationStack {
        newDeviceView(vm: .init(provider: .shared))
    }
}
