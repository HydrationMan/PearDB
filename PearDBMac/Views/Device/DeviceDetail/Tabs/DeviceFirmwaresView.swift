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
                    DeviceFirmwareDetail(device: device, firmware: firmware, offset: offset)
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
