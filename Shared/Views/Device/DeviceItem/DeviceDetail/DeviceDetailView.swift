//
//  DeviceDetailView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI
import OSLog

struct DeviceDetailView: View {
    @Environment(\.presentations) private var presentations
    
    @FetchRequest(sortDescriptors: []) var storedData: FetchedResults<Entry>
    var device: Device
    var fromDB: Bool = false
    @State var selection = 0
    @State var isAddDeviceDialogOpened = false
    @State var savedDevices: [Entry] = []
    @State var isDeviceAlreadySaved = false
    @State var isLoading = true
    
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
                VStack {
            #if os(macOS)
                    HStack(alignment: .top) {
                        HStack(alignment: .center) {
                            if !device.imageUrl.isEmpty {
                                HStack {
                                    ZStack {
                                        ForEach(Array(device.imageUrl.enumerated()), id: \.offset) { offset, imageUrl in
                                            AsyncImageView(url: imageUrl)
                                                .frame(width: 128, height: 256)
                                                .offset(x: 100 * CGFloat(offset))
                                                .shadow(radius: 8)
                                        }
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
                        AddDeviceButtonView(isLoading: isLoading, isDeviceAlreadySaved: isDeviceAlreadySaved, fromDB: fromDB) {
                            isAddDeviceDialogOpened.toggle()
                        }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThickMaterial)
                    .compositingGroup()
                    .shadow(radius: 5)
                #else
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(device.name)
                                .font(.title)
                            Spacer()
                            AddDeviceButtonView(isLoading: isLoading, isDeviceAlreadySaved: isDeviceAlreadySaved, fromDB: fromDB) {
                                isAddDeviceDialogOpened.toggle()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            ZStack {
                                ForEach(Array(device.imageUrl.enumerated()), id: \.offset) { offset, imageUrl in
                                    AsyncImageView(url: imageUrl)
                                        .frame(width: 64, height: 128)
                                        .offset(x: 48 * CGFloat(offset))
                                        .shadow(radius: 8)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.ultraThickMaterial)
                    .compositingGroup()
                    .shadow(radius: 5)
                #endif
                
                #if os(macOS)
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
                #else
                    Picker("", selection: $selection) {
                        Text("Device Info")
                            .tag(0)
                        Text("Device Firmware")
                            .tag(1)
                    }
                    .padding(.horizontal, 16)
                    .pickerStyle(.segmented)
                    
                    if selection == 0 {
                        DeviceInfoView(device: device)
                            .padding(.horizontal, 16)
                    } else {
                        DeviceFirmwaresView(device: device)
                            .environmentObject(deviceFirmwaresViewModel)
                            .padding(.horizontal ,16)
                    }
                #endif
            }
        }
        .onAppear {
            Task {
                deviceFirmwaresViewModel.filterFirmwares(device: device)
                self.savedDevices = storedData.filter({ data in
                    data.key == device.key
                })
                self.isDeviceAlreadySaved = self.savedDevices.count > 0
                if !self.isDeviceAlreadySaved {
                    dbViewModel.selectedEntry = nil
                }
                self.isLoading = false
            }
        }
        .sheet(isPresented: $isAddDeviceDialogOpened) {
            if !isDeviceAlreadySaved {
                AddDeviceModalView(device: device)
                    .environment(\.presentations, presentations + [$isAddDeviceDialogOpened])
            } else {
                ListSavedDevicesToEdit(device: device)
                    .environment(\.presentations, presentations + [$isAddDeviceDialogOpened])
            }
        }
    }
}
