//
//  DeviceFirmwares.swift
//  PearDBMac
//
//  Created by Paras KCD on 23/2/25.
//

import SwiftUI

struct DeviceFirmwaresView: View {
    var device: Device
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(Array(deviceFirmwaresViewModel.selectedFirmwares.enumerated()), id: \.element.id) { offset, firmware in
                    DeviceFirmwareDetail(device: device, firmware: firmware, offset: offset) {
                        toggleDownload(for: firmware)
                    }
                    .environmentObject(deviceFirmwaresViewModel)
                }
                Color.clear.padding()
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
            }
        }
    }
}

private extension DeviceFirmwaresView {
    func toggleDownload(for firmware: Firmware) {
        if firmware.state == .dowloading {
            deviceFirmwaresViewModel.cancelDownload(for: firmware, deviceKey: device.key)
        } else {
            Task { try? await deviceFirmwaresViewModel.downloadFirmware(deviceKey: device.key, firmware: firmware) }
        }
    }
}
