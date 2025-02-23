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
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            
            VStack {
                HStack(alignment: .center) {
                    HStack {
                        AsyncImageView(url: "https://img.appledb.dev/device@main/\(device.key)/0.png")
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
                .onAppear() {
                    let peardbLogger = Logger.init(
                        subsystem: "com.hydrate.PearDB.device", category: "com.hydrate.PearDB.debug"
                    )
                    peardbLogger.log(level: .error,"""
                    📝 Device: \(device.name)
                        ↳ IDENTIFIER: \(device.identifier ?? ["⚠️ N/A"])
                        ↳ SOC: \(device.soc ?? "⚠️ N/A")
                        ↳ CPID: \(device.cpid ?? "⚠️ N/A")
                        ↳ ARCH: \(device.arch ?? "⚠️ N/A")
                        ↳ TYPE: \(device.type ?? "⚠️ N/A")
                        ↳ BOARD: \(device.board ?? ["⚠️ N/A"])
                        ↳ BDID: \(device.bdid ?? "⚠️ N/A")
                        ↳ MODEL: \(device.model ?? ["⚠️ N/A"])
                        ↳ INFO: \(device.info?.map { "\($0.type) (\($0.Storage ?? "⚠️ N/A") Storage, \($0.RAM ?? "⚠️ N/A") RAM)" }.joined(separator: ", ") ?? "⚠️ N/A")
                        ↳ KEY: \(device.key)
                        ↳ RELEASED: \(device.released ?? "⚠️ N/A")
                    """)
                }
//                ScrollView {
//                    
//                }
            }
        }
    }
}
