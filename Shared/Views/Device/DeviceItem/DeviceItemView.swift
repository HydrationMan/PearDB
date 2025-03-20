//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct DeviceItemView: View {
    var device: Device
    var entry: Entry?
    var firmware: Firmware?
    var fromDB: Bool
    
    var body: some View {
        NavigationLink(destination: DeviceDetailView(device: device, fromDB: fromDB)) {
            HStack {
                if !device.imageUrl.isEmpty {
                    AsyncImageView(url: device.imageUrl[0])
                        .frame(width: 32, height: 64)
                }
                
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
                            HStack(alignment: .center) {
                                Text(device.name)
                                Color.clear.padding(8)
                            }
                        }
                        
                        if let firmware = self.firmware {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Installed \(firmware.osStr)")
                                Text("\(firmware.version) - \(firmware.build ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let serial = entry.serial {
                            HStack(alignment: .center, spacing: 8) {
                                Text("Serial")
                                Text(serial)
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
    }
}
