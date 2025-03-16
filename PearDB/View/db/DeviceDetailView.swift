//
//  DeviceDetailView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct DeviceDetailView: View {
    @FetchRequest(sortDescriptors: []) var storedData: FetchedResults<Entry>
    @ObservedObject var device: Device
    var fromDB: Bool = false
    @State private var selection = 0
    @State private var isAddDeviceDialogOpened = false
    @State private var isDeviceAlreadySaved = false
    @State private var isLoading = true

    @Environment(\.dismiss) private var dismiss
    @StateObject private var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init()

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    HStack(alignment: .center) {
                        AsyncImageView(url: "https://img.appledb.dev/device@256/\(device.key)/0.png")
                            .frame(width: 128, height: 256)
                        VStack(alignment: .leading) {
                            Text(device.name)
                                .font(.largeTitle)
                            Text("Released: \(device.released ?? "unknown")")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text("Chip: \(device.soc ?? "unknown")")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text("Model(s): \(device.model?.joined(separator: ", ") ?? "unknown")")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if !isLoading {
                        VStack(alignment: .trailing) {
                            HStack {
                                Button {
                                    isAddDeviceDialogOpened.toggle()
                                } label: {
                                    Label(isDeviceAlreadySaved ? "Edit Device" : "Add Device", systemImage: "macbook.and.iphone")
                                        .frame(maxWidth: 128)
                                        .padding(16)
                                        .background(.thickMaterial)
                                        .cornerRadius(99)
                                        .overlay(RoundedRectangle(cornerRadius: 99).stroke(Color(.separator), lineWidth: 1))
                                }
                                .buttonStyle(.plain)

                                if fromDB {
                                    XMarkButtonView(action: { dismiss() })
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThickMaterial)
                .shadow(radius: 5)
                .border(width: 1, edges: [.bottom], color: Color(.gray))

                TabView(selection: $selection) {
                    DeviceInfoView(device: device)
                        .tabItem {
                            Label("Device Info", systemImage: "info.circle.fill")
                        }
                        .tag(0)
                    DeviceFirmwaresView(device: device)
                        .tabItem {
                            Label("Device Firmwares", systemImage: "terminal")
                        }
                        .tag(1)
                        .environmentObject(deviceFirmwaresViewModel)
                }
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                self.isDeviceAlreadySaved = storedData.contains { $0.key == device.key }
                self.isLoading = false
            }
        }
        .sheet(isPresented: $isAddDeviceDialogOpened) {
            if !isDeviceAlreadySaved {
                AddDeviceModalView(device: device)
                    .environmentObject(deviceFirmwaresViewModel)
            } else if let entry = storedData.first(where: { $0.key == device.key }) {
                AddDeviceModalView(device: device, storedEntry: entry)
                    .environmentObject(deviceFirmwaresViewModel)
            }
        }
    }
}
