//
//  FirmwareItemView.swift
//  PearDB
//
//  Created by Paras KCD on 22/3/25.
//

import SwiftUI

struct FirmwareItemView: View {
    var firmware: Firmware
    
    var body: some View {
        NavigationLink(destination: FirmwareDetailView(firmware: firmware)) {
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
                    AsyncImageView(url: "https://img.appledb.dev/images@preview/\(image)/0.png")
                        .frame(width: 32, height: 32)
                } else {
                    Color.clear.frame(width: 32, height: 32)
                }
                VStack {
                    Text("\(firmware.osStr) \(firmware.version) ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let build = firmware.build {
                        Text("Build: \(build)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
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
            Spacer()
            HStack {
                Text(firmware.released ?? "")
                Image(systemName: "chevron.forward")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
    }
}
