//
//  FirmwareItemView.swift
//  PearDB
//
//  Created by Paras KCD on 22/3/25.
//

import SwiftUI

struct FirmwareItemView: View {
    var firmware: Firmware
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var body: some View {
        NavigationLink(destination: FirmwareDetailView(firmware: firmware)
            .environmentObject(deviceViewModel)
            .environmentObject(deviceFirmwaresViewModel)
            .environmentObject(dbViewModel)) {
            FirmwareItemLabelView(firmware: firmware)
        }
        .buttonStyle(.plain)
    }
}

struct FirmwareItemLabelView: View {
    var firmware: Firmware
    
    var body: some View {
        HStack {
            HStack {
                if let image = firmware.appledbWebImage?.id {
                    AsyncImageView(url: "https://img.appledb.dev/images@preview/\(image)/0.png", key: firmware.key)
                    #if os(tvOS)
                        .frame(width: 64, height: 64)
                    #else
                        .frame(width: 32, height: 32)
                    #endif
                } else {
                    #if os(tvOS)
                    Color.clear.frame(width: 64, height: 64)
                    #else
                    Color.clear.frame(width: 32, height: 32)
                    #endif
                    
                }
                VStack {
                    Text("\(firmware.osStr) \(firmware.version) ")
                    #if os(tvOS)
                        .font(.system(size: 30))
                    #endif
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let build = firmware.build {
                        Text("Build: \(build)")
                        #if os(tvOS)
                            .font(.system(size: 30))
                        #endif
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .center) {
                    switch(true) {
                    case firmware.rc:
                        Text("RC")
                        #if os(tvOS)
                            .font(.system(size: 30))
                        #else
                            .font(.subheadline)
                        #endif
                            .foregroundColor(.secondary)
                    case firmware.beta:
                        Text("Beta")
                        #if os(tvOS)
                            .font(.system(size: 30))
                        #else
                            .font(.subheadline)
                        #endif
                            .foregroundColor(.secondary)
                    default:
                        Text("Release")
                        #if os(tvOS)
                            .font(.system(size: 30))
                        #else
                            .font(.subheadline)
                        #endif
                    }
                }
                .padding(8)
                .background(.ultraThickMaterial)
                .cornerRadius(99)
            }
            Spacer()
            HStack {
                Text(firmware.released ?? "")
                #if os(tvOS)
                    .font(.system(size: 30))
                #endif
                Image(systemName: "chevron.forward")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
        .visionOSMods.cornerRadius(99)
        .visionOSMods.padding3D("depth")
    }
}
