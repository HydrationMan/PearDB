//
//  DeviceFirmwareDetail.swift
//  PearDBMac
//
//  Created by Paras KCD on 25/2/25.
//

import SwiftUI

struct DeviceFirmwareDetail: View {
    let device: Device
    let firmware: Firmware
    let offset: Int
    @State var isSigned: Bool = false
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Text(firmware.version)
                .font(.title3)
                .frame(width: 72, alignment: .leading)
            if (isSigned) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .renderingMode(.template)
                        .foregroundStyle(.green)
                    Text("Signed")
                        .foregroundStyle(.secondary)
                }
                
            } else {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "x.circle.fill")
                        .renderingMode(.template)
                        .foregroundStyle(.red)
                    Text("Not Signed")
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(firmware.released ?? "")
                .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
        .onAppear {
            Task {
                if (firmware.build != nil) {
                    let getSigned = await deviceFirmwaresViewModel.checkIfSigned(build: firmware.build!, deviceKey: device.key)
                    if (getSigned != nil) {
                        isSigned = getSigned!
                    }
                }
            }
        }
    }
}
