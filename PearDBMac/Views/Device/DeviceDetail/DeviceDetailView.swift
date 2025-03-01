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
    var fromDB: Bool = false
    var addDevice: ((_ device: Entry) -> Void)? = nil
    @State var selection = 0
    @State var isAddDeviceDialogOpened = false
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel = .init()
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            
            VStack {
                HStack(alignment: .top) {
                    HStack(alignment: .center) {
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
                    VStack(alignment: .trailing) {
                        HStack(alignment: .center) {
                            if fromDB {
                                Button {
                                    isAddDeviceDialogOpened.toggle()
                                } label: {
                                    Label {
                                        Text("Add Device")
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
                                
                                XMarkButtonView(action: { dismiss() })
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
            }
        }
        .sheet(isPresented: $isAddDeviceDialogOpened) {
            AddDeviceModalView(device: device) { entry in
                addDevice!(entry)
            }
            .environmentObject(deviceFirmwaresViewModel)
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
    @FocusState private var emailFieldIsFocused: Bool
    
    var addDevice: (_ device: Entry) -> Void
    
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
                    .focused($emailFieldIsFocused)
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
                GenericButtonView(label: "Add") {
                    let entry = Entry(context: moc)
                    entry.key = device.key
                    entry.type = device.type
                    entry.firmware = firmware
                    entry.isMain = isMain
                    entry.serial = serial
                    addDevice(entry)
                    dismiss()
                }
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                selectedList = deviceFirmwaresViewModel.selectedFirmwares
            }
        }
    }
}

enum FirmwareType {
    case release
    case beta
    case rc
}
