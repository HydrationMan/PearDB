//
//  DeviceItemView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct DeviceItemView: View {
    @ObservedObject var device: Device
    var entry: Entry?
    var firmware: Firmware?
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    
    var body: some View {
        NavigationLink(destination: DeviceDetailView(device: device)) {
            HStack {
                AsyncImageView(url: "https://img.appledb.dev/device@64/\(device.key)/0.png")
                    .frame(width: 32, height: 64)
                VStack(alignment: .leading) {
                    if let entry = self.entry {
                        if entry.isMain {
                            HStack(alignment: .center) {
                                Text(device.name)
                                HStack(alignment: .center) {
                                    Text("Main Device")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(8)
                                .background(.thickMaterial)
                                .cornerRadius(99)
                            }
                        } else {
                            Text(device.name)
                        }
                        
                        if let firmware = self.firmware {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Installed \(firmware.osStr)")
                                Text("\(firmware.version) - \(firmware.build ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        Text(device.name)
                        Text(device.type ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Image(systemName: "chevron.forward")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .onDisappear(perform: delayText)

    }
    
    private func delayText() {
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        dbViewModel.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dbViewModel.isLoading = false
        }
    }
}
