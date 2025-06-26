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
    @FocusState private var isReleaseTypeMenuFocus: Bool
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                    .frame(maxWidth: .infinity)
                Spacer()
                    .frame(maxWidth: .infinity)
                DeviceFirmwareReleaseTypeMenu(focus: $isReleaseTypeMenuFocus)
                    .environmentObject(deviceFirmwaresViewModel)
            }
            LazyVStack(alignment: .leading) {
                ForEach(Array(selectedFirmwares.enumerated()), id: \.element.id) { offset, firmware in
                    DeviceFirmwareDetail(device: device, firmware: firmware, offset: offset) {
                        toggleDownload(for: firmware)
                    }
                    .environmentObject(deviceFirmwaresViewModel)
                    .visionOSMods.padding3D("depth")
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
    var selectedFirmwares: [Firmware] {
        switch (deviceFirmwaresViewModel.selectedFirmwareReleaseType) {
        case .release: return deviceFirmwaresViewModel.selectedFirmwares
        case .beta: return deviceFirmwaresViewModel.betaFirmwares
        case .rc: return deviceFirmwaresViewModel.rcFirmwares
        default: return deviceFirmwaresViewModel.selectedFirmwares
        }
    }
    
    func toggleDownload(for firmware: Firmware) {
        if firmware.state == .dowloading {
            deviceFirmwaresViewModel.cancelDownload(for: firmware, deviceKey: device.key)
        } else {
            Task { try? await deviceFirmwaresViewModel.downloadFirmware(deviceKey: device.key, firmware: firmware) }
        }
    }
}

struct DeviceFirmwareReleaseTypeMenu: View {
    @FocusState.Binding var focus: Bool
    let firmwareTypes: [FirmwareType] = FirmwareType.allCases
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    
    var body: some View {
        Menu {
            ForEach(Array(firmwareTypes.filter({$0 != .simulator && $0 != .sdk}).enumerated()), id: \.offset) { offset, firmwareType in
                Button(firmwareType.rawValue) {
                    deviceFirmwaresViewModel.changeFirmwareReleaseType(releaseType: firmwareType)
                }
            }
        } label: {
            Label {
                Text(deviceFirmwaresViewModel.selectedFirmwareReleaseType.rawValue)
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .containerShape(RoundedRectangle(cornerRadius: 99))
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .padding(8)
        #if os(tvOS)
        .background(focus ? Color.blue : Color.gray)
        #else
        .background(.thickMaterial)
        #endif
        .cornerRadius(99)
        .overlay {
            #if os(macOS)
            RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
            #else
            RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
            #endif
        }
        .visionOSMods.padding3D("depth")
    }
}
