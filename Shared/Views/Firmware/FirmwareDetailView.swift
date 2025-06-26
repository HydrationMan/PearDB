//
//  FirmwareDetailView.swift
//  PearDB
//
//  Created by Paras KCD on 22/3/25.
//

import SwiftUI

struct FirmwareDetailView: View {
    var firmware: Firmware
    let columns = [GridItem(.adaptive(minimum: 300))]
    
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
            VStack {
                VStack {
                    HStack {
                        if let image = firmware.appledbWebImage?.id {
                            AsyncImageView(url: "https://img.appledb.dev/images@preview/\(image)/0.png")
                            #if os(tvOS)
                                .frame(width: 64, height: 64)
                            #else
                                .frame(width: 32, height: 32)
                            #endif
                                .visionOSMods.padding3D("depth")
                        }
                        VStack {
                            Text("\(firmware.osStr) \(firmware.version) ")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title)
                            if let build = firmware.build {
                                Text("Build: \(build)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 20))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(alignment: .center) {
                            switch(true) {
                            case firmware.rc:
                                Text("RC")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            case firmware.beta:
                                Text("Beta")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            default:
                                Text("Release")
                                    .font(.subheadline)
                            }
                        }
                        .padding(8)
                        .background(.thickMaterial)
                        .cornerRadius(99)
                    }
                    Text("Devices")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThickMaterial)
                .compositingGroup()
                .shadow(radius: 5)
                
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                        #if os(iOS)
                        Color.clear.frame(height: 1)
                        #endif
                        ForEach(filterDevices(), id: \.id) { device in
                            DeviceItemView(device: device)
                                .visionOSMods.padding3D("depth")
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func filterDevices() -> [Device] {
        let devices = deviceViewModel.devices.filter { device in
            self.firmware.deviceMap.contains(device.key)
        }
        return devices.sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending } )
    }
}
