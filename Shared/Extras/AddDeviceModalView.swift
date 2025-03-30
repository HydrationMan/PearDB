//
//  AddDeviceModalView.swift
//  PearDB
//
//  Created by Paras KCD on 20/3/25.
//

import SwiftUI

struct AddDeviceModalView: View {
    @Environment(\.presentations) var presentations
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var device: Device
    @State var selectedList: [Firmware] = []
    
    // Form Stuff
    @State var firmwareType: FirmwareType = .release
    @State var firmware: String? = nil
    @State var isMain: Bool = false
    @State var serial: String = ""
    @FocusState private var serialFieldFocused: Bool
    
    var body: some View {
        VStack {
            HeaderView(title: "Add \(device.name)?") {
                XMarkButtonView {
                    dismiss()
                }
            }
            Form {
                Toggle("Is it your main device?", isOn: $isMain)
                
                TextField("Serial", text: $serial)
                    .focused($serialFieldFocused)
                    .disableAutocorrection(true)
                
                Picker(selection: $firmwareType, label: Text("Firmware Type")) {
                    Text("Release").tag(FirmwareType.release)
                    Text("Beta").tag(FirmwareType.beta)
                    Text("RC").tag(FirmwareType.rc)
                }
                .pickerStyle(.menu)
                .onChange(of: firmwareType) {
                    switch(firmwareType) {
                    case .beta:
                        selectedList = deviceFirmwaresViewModel.betaFirmwares
                        break
                    case .rc:
                        selectedList = deviceFirmwaresViewModel.rcFirmwares
                        break
                    default:
                        selectedList = deviceFirmwaresViewModel.selectedFirmwares
                        break
                    }
                }
                
                Picker(selection: $firmware, label: Text("Firmware")) {
                    Color.clear.tag(Optional<String>(nil))
                    ForEach(selectedList, id: \.key) { firmware in
                        Text(firmware.version).tag(firmware.key)
                    }
                }
            }
            .padding()
            
            FooterView {
                GenericButtonView(label: "Cancel") {
                    dismiss()
                }
                GenericButtonView(label: dbViewModel.selectedEntry != nil ? "Edit Device": "Add Device") {
                    if let entry = dbViewModel.selectedEntry {
                        entry.isMain = isMain
                        entry.firmware = firmware
                        entry.serial = serial
                    } else {
                        let entry = Entry(context: moc)
                        entry.id = UUID()
                        entry.key = device.key
                        entry.type = device.type
                        entry.firmware = firmware
                        entry.isMain = isMain
                        entry.serial = serial
                        entry.version = "2.0"
                    }
                    try? moc.save()
                    presentations.forEach {
                        $0.wrappedValue = false
                    }
                }
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                selectedList = deviceFirmwaresViewModel.selectedFirmwares
                
                if let guardingStoredEntry = dbViewModel.selectedEntry {
                    if let storedFirmware = deviceFirmwaresViewModel.firmwares.first(where: { $0.key == guardingStoredEntry.firmware }) {
                        switch(true) {
                        case storedFirmware.beta:
                            self.firmwareType = .beta
                            break
                        case storedFirmware.rc:
                            self.firmwareType = .rc
                            break
                        default:
                            self.firmwareType = .release
                            break
                        }
                        
                        self.firmware = storedFirmware.key
                    }
                    
                    self.isMain = guardingStoredEntry.isMain
                    self.serial = guardingStoredEntry.serial ?? ""
                }
            }
        }
    }
}
