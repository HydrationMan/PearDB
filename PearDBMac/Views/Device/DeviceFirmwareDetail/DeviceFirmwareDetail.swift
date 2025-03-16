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
    let onButtonPressed: () -> Void
    @State var isSigned: Bool = false
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    
    var body: some View {
        VStack {
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
                Button {
                    onButtonPressed()
                } label: {
                    Label {
                        Text(buttonLabel)
                    } icon: {
                        Image(systemName: buttonImageName)
                    }
                    .frame(minWidth: 72)
                    .font(.headline)
                    .containerShape(RoundedRectangle(cornerRadius: 99))
                    .padding(16)
                    .background(.thinMaterial)
                    .cornerRadius(99)
                    .overlay {
                        RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(8)
            if firmware.progress > 0 && !firmware.isDownloadCompleted {
                ProgressView(value: firmware.progress)
                    .padding(.horizontal, 16)
            }
        }
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

private extension DeviceFirmwareDetail {
    var buttonLabel: String {
        switch(firmware.isDownloadCompleted, firmware.state) {
        case (true, _): return "Downloaded"
        case (false, .dowloading): return "Downloading"
        case (false, _): return "Download"
        }
    }
    var buttonImageName: String {
        switch(firmware.isDownloadCompleted, firmware.state) {
        case (true, _): return "checkmark.circle.fill"
        case (false, .dowloading): return "pause.fill"
        case (false, _): return "tray.and.arrow.down"
        }
    }
}
