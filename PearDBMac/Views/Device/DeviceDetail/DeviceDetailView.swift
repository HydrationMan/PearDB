//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI
import OSLog

struct DeviceDetailView: View {
    @FetchRequest(sortDescriptors: []) var storedData: FetchedResults<Entry>
    var device: Device
    var fromDB: Bool = false
    @State var selection = 0
    @State var isAddDeviceDialogOpened = false
    @State var isDeviceAlreadySaved = false
    @State var isLoading = true
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init()
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            
            VStack {
                HStack(alignment: .top) {
                    HStack(alignment: .center) {
                        if !device.imageUrl.isEmpty {
                            ZStack {
                                ForEach(Array(device.imageUrl.enumerated()), id: \.offset) { offset, imageUrl in
                                    AsyncImageView(url: imageUrl)
                                        .frame(width: 128, height: 256)
                                        .offset(x: 100 * CGFloat(offset))
                                        .shadow(radius: 8)
                                }
                            }
                            .padding(.trailing, 90 * CGFloat(device.imageUrl.count))
                        }
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
                    if !isLoading {
                        VStack(alignment: .trailing) {
                            HStack(alignment: .center) {
                                Button {
                                    isAddDeviceDialogOpened.toggle()
                                } label: {
                                    Label {
                                        Text(isDeviceAlreadySaved ? "Edit Device" : "Add Device")
                                    } icon: {
                                        Image(systemName: "macbook.and.iphone")
                                    }
                                    .containerShape(RoundedRectangle(cornerRadius: 99))
                                    .frame(maxWidth: 128)
                                    .padding(16)
                                    .background(.thickMaterial)
                                    .cornerRadius(99)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if fromDB {
                                    XMarkButtonView(action: { dismiss() })
                                }
                            }
                            
                        }
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
                    DeviceFirmwaresView(device: device)
                        .tabItem({
                            Label {
                                Text("Device Firmwares")
                            } icon: {
                                Image(systemName: "terminal")
                            }
                        })
                        .tag(1)
                        .environmentObject(deviceFirmwaresViewModel)
                        .padding(.horizontal ,16)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                self.isDeviceAlreadySaved = storedData.contains(where: { data in
                    data.key == device.key
                })
                self.isLoading = false
            }
        }
        .sheet(isPresented: $isAddDeviceDialogOpened) {
            if !isDeviceAlreadySaved {
                AddDeviceModalView(device: device)
                .environmentObject(deviceFirmwaresViewModel)
            } else {
                if let entry = storedData.first(where: {$0.key == device.key}) {
                    AddDeviceModalView(device: device, storedEntry: entry)
                    .environmentObject(deviceFirmwaresViewModel)
                }
            }
        }
    }
}

struct AddDeviceModalView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    
    var device: Device
    @State var selectedList: [Firmware] = []
    
    // Form Stuff
    @State var firmwareType: FirmwareType = .release
    @State var firmware: String? = nil
    @State var isMain: Bool = false
    @State var serial: String = ""
    @FocusState private var serialFieldFocused: Bool
    @State var storedEntry: Entry? = nil
    
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
                .pickerStyle(.radioGroup)
                .horizontalRadioGroupLayout()
                .onChange(of: firmwareType) {
                    switch(firmwareType) {
                    case .beta:
                        selectedList = deviceFirmwaresViewModel.betaFirmwares
                        break
                    case .rc:
                        selectedList = deviceFirmwaresViewModel.rcFirmwares
                        break
                    case .release:
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
                GenericButtonView(label: storedEntry != nil ? "Edit Device": "Add Device") {
                    if storedEntry == nil {
                        let entry = Entry(context: moc)
                        entry.key = device.key
                        entry.type = device.type
                        entry.firmware = firmware
                        entry.isMain = isMain
                        entry.serial = serial
                    } else {
                        if let entry = storedEntry {
                            entry.isMain = isMain
                            entry.firmware = firmware
                            entry.serial = serial
                        }
                    }
                    try? moc.save()
                    dismiss()
                }
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                selectedList = deviceFirmwaresViewModel.selectedFirmwares
                
                if let guardingStoredEntry = storedEntry {
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

enum FirmwareType {
    case release
    case beta
    case rc
}
