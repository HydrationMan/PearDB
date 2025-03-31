//
//  DeviceSectionView.swift
//  PearDBMac
//
//  Created by Paras KCD on 23/2/25.
//

import SwiftUI

struct DeviceSectionView: View {
    let columns = [GridItem(.adaptive(minimum: 400))]
    
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
            NavigationStack {
                TabView(selection: $deviceViewModel.selectedDeviceGroup) {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .iphone)
                            DeviceSectionItemView(deviceType: .ipad)
                            DeviceSectionItemView(deviceType: .ipadAir)
                            DeviceSectionItemView(deviceType: .ipadPro)
                            DeviceSectionItemView(deviceType: .ipadMini)
                            DeviceSectionItemView(deviceType: .ipodTouch)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.iOSDevices.rawValue, systemImage: "ipad.landscape.and.iphone")
                    }
                    .tag(DeviceGroupType.iOSDevices)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .macBookAir)
                            DeviceSectionItemView(deviceType: .macBookPro)
                            DeviceSectionItemView(deviceType: .macBook)
                            DeviceSectionItemView(deviceType: .imac)
                            DeviceSectionItemView(deviceType: .macMini)
                            DeviceSectionItemView(deviceType: .macStudio)
                            DeviceSectionItemView(deviceType: .macPro)
                            DeviceSectionItemView(deviceType: .powerBook)
                            DeviceSectionItemView(deviceType: .powerMac)
                            DeviceSectionItemView(deviceType: .powerBook)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.macs.rawValue, systemImage: "desktopcomputer.and.macbook")
                    }
                    .tag(DeviceGroupType.macs)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .appleWatch)
                            DeviceSectionItemView(deviceType: .appleTV)
                            DeviceSectionItemView(deviceType: .homePod)
                            DeviceSectionItemView(deviceType: .headset)
                            DeviceSectionItemView(deviceType: .display)
                            DeviceSectionItemView(deviceType: .airTag)
                            DeviceSectionItemView(deviceType: .airPort)
                            DeviceSectionItemView(deviceType: .power)
                            DeviceSectionItemView(deviceType: .adapters)
                            DeviceSectionItemView(deviceType: .cases)
                            DeviceSectionItemView(deviceType: .beddit)
                            DeviceSectionItemView(deviceType: .accessories)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.homeAndAccessories.rawValue, systemImage: "homepod.and.appletv")
                    }
                    .tag(DeviceGroupType.homeAndAccessories)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .airPods)
                            DeviceSectionItemView(deviceType: .audio)
                            DeviceSectionItemView(deviceType: .beatsEarbuds)
                            DeviceSectionItemView(deviceType: .beatsHeadphones)
                            DeviceSectionItemView(deviceType: .beatsSpeakers)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.audio.rawValue, systemImage: "airpods.max")
                    }
                    .tag(DeviceGroupType.audio)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .ipodTouch)
                            DeviceSectionItemView(deviceType: .ipodNano)
                            DeviceSectionItemView(deviceType: .ipodShuffle)
                            DeviceSectionItemView(deviceType: .ipodMini)
                            DeviceSectionItemView(deviceType: .ipod)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.iPods.rawValue, systemImage: "ipod")
                    }
                    .tag(DeviceGroupType.iPods)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            DeviceSectionItemView(deviceType: .applePencil)
                            DeviceSectionItemView(deviceType: .mouse)
                            DeviceSectionItemView(deviceType: .trackpad)
                            DeviceSectionItemView(deviceType: .keyboard)
                            DeviceSectionItemView(deviceType: .remote)
                        }
                    }
                    .tabItem {
                        Label(DeviceGroupType.inputs.rawValue, systemImage: "keyboard")
                    }
                    .tag(DeviceGroupType.inputs)
                    .padding(.horizontal)
                }
                #if os(macOS)
                .padding()
                #endif
            }
            .navigationTitle("Devices")
        }
    }
}

struct DeviceSectionItemView: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @EnvironmentObject var deviceFirmwaresViewModel: DeviceFirmwaresViewModel
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var deviceType: DeviceType
    
    var body: some View {
        NavigationLink(destination: DeviceView(selectedFilter: deviceType)
            .environmentObject(deviceViewModel)
            .environmentObject(deviceFirmwaresViewModel)
            .environmentObject(dbViewModel)) {
            VStack(alignment: .center) {
                if let deviceImage = deviceViewModel.devices.filter({ $0.deviceType == deviceType }).sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending }).last(where: { $0.imageUrl.count > 0 })?.imageUrl[0] {
                    AsyncImageView(url: deviceImage)
                        .frame(width: 128, height: 256)
                } else if deviceViewModel.isLoading {
                    VStack {
                        ProgressView()
                    }
                    .frame(width:128, height: 256)
                } else {
                    Color.clear.frame(width:128, height: 256)
                }
                
                Text(deviceType.rawValue)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.regularMaterial)
            .contentShape(Rectangle())
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
