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
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            NavigationStack {
                ScrollView {
                    TabView(selection: $deviceViewModel.selectedDeviceGroup) {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.iphone)) {
                                DeviceSectionItemView(deviceType: .iphone)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipad)) {
                                DeviceSectionItemView(deviceType: .ipad)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadAir)) {
                                DeviceSectionItemView(deviceType: .ipadAir)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadPro)) {
                                DeviceSectionItemView(deviceType: .ipadPro)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadMini)) {
                                DeviceSectionItemView(deviceType: .ipadMini)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .ipodTouch)) {
                                DeviceSectionItemView(deviceType: .ipodTouch)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        .tabItem {
                            Text(DeviceGroupType.iOSDevices.rawValue)
                        }
                        .tag(DeviceGroupType.iOSDevices)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBookAir)) {
                                DeviceSectionItemView(deviceType: .macBookAir)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBookPro)) {
                                DeviceSectionItemView(deviceType: .macBookPro)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBook)) {
                                DeviceSectionItemView(deviceType: .macBook)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.imac)) {
                                DeviceSectionItemView(deviceType: .imac)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macMini)) {
                                DeviceSectionItemView(deviceType: .macMini)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .macStudio)) {
                                DeviceSectionItemView(deviceType: .macStudio)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .macPro)) {
                                DeviceSectionItemView(deviceType: .macPro)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerBook)) {
                                DeviceSectionItemView(deviceType: .powerBook)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerMac)) {
                                DeviceSectionItemView(deviceType: .powerMac)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerBook)) {
                                DeviceSectionItemView(deviceType: .powerBook)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        .tabItem {
                            Text(DeviceGroupType.macs.rawValue)
                        }
                        .tag(DeviceGroupType.macs)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.appleWatch)) {
                                DeviceSectionItemView(deviceType: .appleWatch)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.appleTV)) {
                                DeviceSectionItemView(deviceType: .appleTV)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.homePod)) {
                                DeviceSectionItemView(deviceType: .homePod)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.headset)) {
                                DeviceSectionItemView(deviceType: .headset)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.display)) {
                                DeviceSectionItemView(deviceType: .display)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .airTag)) {
                                DeviceSectionItemView(deviceType: .airTag)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .airPort)) {
                                DeviceSectionItemView(deviceType: .airPort)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .power)) {
                                DeviceSectionItemView(deviceType: .power)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .adapters)) {
                                DeviceSectionItemView(deviceType: .adapters)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .cases)) {
                                DeviceSectionItemView(deviceType: .cases)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .beddit)) {
                                DeviceSectionItemView(deviceType: .beddit)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .accessories)) {
                                DeviceSectionItemView(deviceType: .accessories)
                            }
                            .buttonStyle(.plain)
                        }
                        .tabItem {
                            Text(DeviceGroupType.homeAndAccessories.rawValue)
                        }
                        .tag(DeviceGroupType.homeAndAccessories)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.airPods)) {
                                DeviceSectionItemView(deviceType: .airPods)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.audio)) {
                                DeviceSectionItemView(deviceType: .audio)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsEarbuds)) {
                                DeviceSectionItemView(deviceType: .beatsEarbuds)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsHeadphones)) {
                                DeviceSectionItemView(deviceType: .beatsHeadphones)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsSpeakers)) {
                                DeviceSectionItemView(deviceType: .beatsSpeakers)
                            }
                            .buttonStyle(.plain)
                        }
                        .tabItem {
                            Text(DeviceGroupType.audio.rawValue)
                        }
                        .tag(DeviceGroupType.audio)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodTouch)) {
                                DeviceSectionItemView(deviceType: .ipodTouch)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodNano)) {
                                DeviceSectionItemView(deviceType: .ipodNano)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodShuffle)) {
                                DeviceSectionItemView(deviceType: .ipodShuffle)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodMini)) {
                                DeviceSectionItemView(deviceType: .ipodMini)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipod)) {
                                DeviceSectionItemView(deviceType: .ipod)
                            }
                            .buttonStyle(.plain)
                        }
                        .tabItem {
                            Text(DeviceGroupType.iPods.rawValue)
                        }
                        .tag(DeviceGroupType.iPods)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.applePencil)) {
                                DeviceSectionItemView(deviceType: .applePencil)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.mouse)) {
                                DeviceSectionItemView(deviceType: .mouse)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.trackpad)) {
                                DeviceSectionItemView(deviceType: .trackpad)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.keyboard)) {
                                DeviceSectionItemView(deviceType: .keyboard)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.remote)) {
                                DeviceSectionItemView(deviceType: .remote)
                            }
                            .buttonStyle(.plain)
                        }
                        .tabItem {
                            Text(DeviceGroupType.inputs.rawValue)
                        }
                        .tag(DeviceGroupType.inputs)
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
    }
}

struct DeviceSectionItemView: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    var deviceType: DeviceType
    
    var body: some View {
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
}
