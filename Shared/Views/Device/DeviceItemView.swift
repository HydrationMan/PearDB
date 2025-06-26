//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI
import Foundation

let deviceKeyMappings = [["iPhone5,3", "iPhone5,4"], ["iPhone6,1", "iPhone6,2"], ["iPhone9,1", "iPhone9,3"], ["iPhone9,2", "iPhone9,4"], ["iPhone10,1", "iPhone10,4"], ["iPhone10,2", "iPhone10,5"], ["iPhone10,3", "iPhone10,6"], ["iPhone11,6", "iPhone11,4"]]

struct DeviceItemView: View {
    var device: Device
    var entry: Entry?
    var firmware: Firmware?
    var fromSheet: Bool?
    
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var body: some View {
        NavigationLink(destination: DeviceDetailView(device: device)
            .environmentObject(deviceFirmwaresViewModel)
            .environmentObject(dbViewModel)) {
            DeviceItemLabelView(device: device, entry: entry, firmware: firmware)
        }
        .buttonStyle(.plain)
    }
}

struct DeviceItemLabelView: View {
    var device: Device
    var entry: Entry?
    var firmware: Firmware?
    
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var mappedImageKey: String {
        for pair in deviceKeyMappings where pair.count > 1 && pair[1] == device.key {
            return pair[0]
        }
        return device.key
    }
    
    var body: some View {
        HStack {
            if let firstUrl = device.imageUrl.first, !device.imageUrl.isEmpty {
                AsyncImageView(url: firstUrl)
                    .frame(width: 32, height: 64)
            } else if let deviceImages = dbViewModel.images.first(where: { $0.key == mappedImageKey }),
                      let firstIndex = deviceImages.index.first {
                let urlString = "https://img.appledb.dev/device@256/\(mappedImageKey)/\(firstIndex.idText).png"
                AsyncImageView(url: urlString)
                    .frame(width: 32, height: 64)
            } else {
                Image(.sad)
                    .resizable()
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
        .visionOSMods.cornerRadius(99)
        .visionOSMods.padding3D("depth")
    }
}

