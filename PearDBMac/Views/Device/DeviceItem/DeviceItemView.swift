//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct DeviceItemView: View {
    var device: Device
    
    var body: some View {
        NavigationLink(destination: DeviceDetailView(device: device)) {
            HStack {
                AsyncImageView(url: "https://img.appledb.dev/device@64/\(device.key)/0.png")
                    .frame(width: 32, height: 64)
                VStack(alignment: .leading) {
                    Text(device.name)
                    Text(device.type ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
