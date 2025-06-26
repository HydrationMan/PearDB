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

    var mappedImageKey: String {
        for pair in deviceKeyMappings where pair.count > 1 && pair[1] == device.key {
            return pair[0]
        }
        return device.key
    }
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
                VStack {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(device.name)
                                .font(.title)
                            Spacer()
                            AddDeviceButtonView(isLoading: isLoading, isDeviceAlreadySaved: isDeviceAlreadySaved, fromDB: fromDB) {
                                isAddDeviceDialogOpened.toggle()
                            }
                            .visionOSMods.padding3D("depth")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            ZStack {
                                if !device.imageUrl.isEmpty {
                                    ForEach(Array(device.imageUrl.enumerated()), id: \.offset) { offset, imageUrl in
                                        AsyncImageView(url: imageUrl)
                                            .frame(width: 64, height: 128)
                                            .offset(x: 48 * CGFloat(offset))
                                            .visionOSMods.padding3D("depth", CGFloat(offset) * 2)
                                            .shadow(radius: 8)
                                    }
                                } else if let deviceImages = dbViewModel.images.first(where: { $0.key == mappedImageKey }) {
                                    ForEach(Array(deviceImages.index.enumerated()), id: \.offset) { offset, imageIndex in
                                        let urlString = "https://img.appledb.dev/device@256/\(mappedImageKey)/\(imageIndex.idText).png"
                                        AsyncImageView(url: urlString)
                                            .frame(width: 64, height: 128)
                                            .offset(x: 48 * CGFloat(offset))
                                            .visionOSMods.padding3D("depth", CGFloat(offset) * 2)
                                            .shadow(radius: 8)
                                    }
                                } else {
                                    Image(.sad)
                                        .resizable()
                                        .frame(width: 64, height: 128)
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
                    .visionOSMods.padding3D("depth")
                    
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
