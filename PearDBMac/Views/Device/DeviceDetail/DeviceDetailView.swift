//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI
import OSLog

struct DeviceDetailView: View {
    var device: Device
    @State var selection = 0
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            
            VStack {
                HStack(alignment: .center) {
                    HStack {
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
                    
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.ultraThickMaterial)
                .compositingGroup()
                .shadow(radius: 5)
                .border(width: 1, edges: [.bottom], color: Color(NSColor.gridColor))
                
                TabView(selection: $selection) {
                    DeviceInfoView(device: device)
                    .tabItem({
                        Label {
                            Text("Device Info")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                        }
                    })
                    .tag(0)
                    .padding(.horizontal ,16)
                    DeviceFirmwaresView()
                        .tabItem({
                            Label {
                                Text("Device Firmwares")
                            } icon: {
                                Image(systemName: "terminal")
                            }
                        })
                        .tag(0)
                        .padding(.horizontal ,16)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear() {
            let peardbLogger = Logger.init(
                subsystem: "com.hydrate.PearDB.device", category: "com.hydrate.PearDB.debug"
            )
            peardbLogger.log(level: .error,"""
            📝 Device: \(device.name)
                ↳ IDENTIFIER: \(device.identifier ?? "⚠️ N/A")
                ↳ SOC: \(device.soc ?? "⚠️ N/A")
                ↳ CPID: \(device.cpid ?? "⚠️ N/A")
                ↳ ARCH: \(device.arch ?? "⚠️ N/A")
                ↳ TYPE: \(device.type ?? "⚠️ N/A")
                ↳ BOARD: \(device.board ?? ["⚠️ N/A"])
                ↳ BDID: \(device.bdid ?? "⚠️ N/A")
                ↳ MODEL: \(device.model ?? ["⚠️ N/A"])
                ↳ KEY: \(device.key)
                ↳ RELEASED: \(device.released ?? "⚠️ N/A")
            """)
        }
    }
}


