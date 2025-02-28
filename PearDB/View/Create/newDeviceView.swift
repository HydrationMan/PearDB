//
//  newDeviceView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct newDeviceView: View {
    
    @State private var fwViewSwitch: Bool = false
    @State private var searchText = ""
    @State private var fwSearchText = ""
    @State private var devices: [Device] = []
    @State private var filteredDevices: [Device] = []
    @State private var selectedDevice: Device?
    @State private var showOtherDevices: Bool = false
    @ObservedObject private var downloader = AppleDBDownloader.shared
    @ObservedObject var vm: editDeviceViewModel
    
    private let normalDeviceTypes: Set<String> = [
        "iPhone", "iPod", "iPod mini", "iPod nano", "iPod shuffle", "iPod touch",
        "iPad", "iPad Air", "iPad Pro", "iPad mini",
        "iMac", "MacBook Pro", "MacBook Air", "MacBook", "Mac mini", "Mac Studio", "Mac Pro",
        "HomePod", "headset", "Apple Watch", "AppleTV"
    ]

    var body: some View {
        NavigationView {
            if !fwViewSwitch {
                VStack {
                    TextField("Search devices", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: searchText) { filterDevices() }
                    
                    Toggle(isOn: $showOtherDevices) {
                        Text("Show other devices")
                    }
                    .onChange(of: showOtherDevices) { filterDevices() }
                    .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(filteredDevices, id: \.key) { device in
                                Button(action: {
                                    withAnimation {
                                        selectedDevice = device
                                    }
                                }) {
                                    DeviceCardView(device: device)
                                        .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if let selected = selectedDevice {
                        newDeviceDetailView(device: selected)
                            .transition(.scale.combined(with: .opacity))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                            .shadow(radius: 5)
                    }
                }
                
            } else {
                VStack {
                    TextField("Search firmwares", text: $fwSearchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        //.onChange(of: fwSearchText) { filterFirmwares() }
                    
                }
            }
        }
        .toolbar {
            ToolbarItem() {
                Button() {
                    withAnimation {
                        fwViewSwitch.toggle()
                    }
                } label: {
                    Text("Next")
                }
            }
        }
        .navigationTitle("Add device")
        .onAppear(perform: loadDeviceData)
    }

    private func loadDeviceData() {
        DispatchQueue.global(qos: .background).async {
            Task {
                if let data = await downloader.loadLocalJSON(named: "device_main") {
                    do {
                        let decodedDevices = try JSONDecoder().decode([Device].self, from: data)
                        DispatchQueue.main.async {
                            withAnimation {
                                self.devices = decodedDevices
                                self.filterDevices()  // Apply filter immediately based on the current toggle state
                            }
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
        withAnimation {
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            let baseDevices = trimmedSearchText.isEmpty
                ? devices
                : devices.filter { device in
                    device.name.range(of: trimmedSearchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                }
            
            // Apply the "Other Devices" filter based on toggle
            filteredDevices = baseDevices.filter { device in
                if let deviceType = device.type {
                    return showOtherDevices
                        ? !normalDeviceTypes.contains(deviceType)
                        : normalDeviceTypes.contains(deviceType)
                }
                return false
            }
        }
    }
}

struct DeviceCardView: View {
    let device: Device

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(device.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let identifier = device.identifier {
                    Text("Identifier: \(identifier)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct newDeviceDetailView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(device.name)")
                .font(.title2)
                .bold()
            if let identifier = device.identifier {
                Text("Identifier: \(identifier)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            if let board = device.board?.joined(separator: ", ") {
                Text("Board: \(board)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            if let model = device.model?.joined(separator: ", ") {
                Text("Model: \(model)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            if let released = device.released {
                Text("Released: \(released)")
                    .font(.body)
                    .foregroundColor(.secondary)
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
