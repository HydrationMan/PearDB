//
//  DeviceFirmwares.swift
//  PearDBMac
//
//  Created by Paras KCD on 23/2/25.
//

import SwiftUI

struct DeviceFirmwaresView: View {
    var device: Device
    @StateObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init(appDbDownloader: AppleDBDownloader.shared)
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(deviceFirmwaresViewModel.selectedFirmwares, id: \.id) { firmware in
                    HStack(alignment: .center) {
                        Text(firmware.version)
                            .font(.title3)
                        Spacer()
                        Text(firmware.released ?? "")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(8)
                }
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
            }
        }
    }
}
