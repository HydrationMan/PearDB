//
//  DeviceSectionView.swift
//  PearDBMac
//
//  Created by Paras KCD on 23/2/25.
//

import SwiftUI

struct DeviceSectionView: View {
    let columns = [GridItem(.adaptive(minimum: 400))]
    
    @StateObject var deviceViewModel: DeviceViewModel = .init()
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            NavigationStack {
                TabView(selection: $deviceViewModel.selectedDeviceGroup) {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.iphone).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPhone17,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.iphone.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipad).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPad13,18/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipad.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadAir).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPad14,10/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipadAir.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadPro).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPad16,5/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipadPro.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipadMini).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPad14,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipadMini.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .ipodTouch).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod9,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipodTouch.rawValue)
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
                    .tabItem {
                        Text(DeviceGroupType.iOSDevices.rawValue)
                    }
                    .tag(DeviceGroupType.iOSDevices)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBookAir).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac15,13/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macBookAir.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBookPro).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac15,7/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macBookPro.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macBook).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/MacBook10,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macBook.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.imac).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac15,4/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.imac.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.macMini).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac14,3/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macMini.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .macStudio).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac14,13/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macStudio.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .macPro).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Mac14,8/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.macPro.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerBook).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/PowerBook6,8/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.powerBook.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerMac).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/PowerMac11,2/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.powerBook.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .powerBook).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/PowerBook6,7-14-inch/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.powerBook.rawValue)
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
                    .tabItem {
                        Text(DeviceGroupType.macs.rawValue)
                    }
                    .tag(DeviceGroupType.macs)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.appleWatch).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Watch7,5/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.appleWatch.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.appleTV).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/AppleTV14,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.appleTV.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.homePod).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/AudioAccessory6,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.homePod.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.headset).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/RealityDevice14,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.headset.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.display).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/AppleDisplay2,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.display.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .airTag).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/AirTag1,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.airTag.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .airPort).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/AirPort Time Capsule (5th generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.airPort.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .power).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/70W USB-C Power Adapter/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.power.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .adapters).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Developer Strap/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.adapters.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .cases).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPhone Pro 15 FineWoven Case with MagSafe/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.cases.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .beddit).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Beddit 3.5 Sleep Monitor/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.beddit.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: .accessories).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Polishing Cloth/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.accessories.rawValue)
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
                    .tabItem {
                        Text(DeviceGroupType.homeAndAccessories.rawValue)
                    }
                    .tag(DeviceGroupType.homeAndAccessories)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.airPods).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Device1,8228-left/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.airPods.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.audio).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/EarPods with Lightning Connector/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.audio.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsEarbuds).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Device1,8221-left/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.beatsEarbuds.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsHeadphones).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/BeatsSolo4,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.beatsHeadphones.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.beatsSpeakers).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/BeatsPill1,2/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.beatsSpeakers.rawValue)
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
                    .tabItem {
                        Text(DeviceGroupType.audio.rawValue)
                    }
                    .tag(DeviceGroupType.audio)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodTouch).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod9,1/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipodTouch.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodNano).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod nano (7th generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipodNano.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodShuffle).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod shuffle (4th generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipodShuffle.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipodMini).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod mini (2nd generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipodMini.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.ipod).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/iPod classic/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.ipod.rawValue)
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
                    .tabItem {
                        Text(DeviceGroupType.iPods.rawValue)
                    }
                    .tag(DeviceGroupType.iPods)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center) {
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.applePencil).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Apple Pencil Pro/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.applePencil.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.mouse).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Magic Mouse (3rd generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.mouse.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.trackpad).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Magic Trackpad (3rd generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.trackpad.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.keyboard).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/Magic Keyboard Folio for iPad (10th generation)/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.keyboard.rawValue)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(.regularMaterial)
                                .contentShape(Rectangle())
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            NavigationLink(destination: DeviceView(selectedFilter: DeviceType.remote).environmentObject(deviceViewModel)) {
                                VStack(alignment: .center) {
                                    AsyncImageView(url: "https://img.appledb.dev/device@preview/ATVRemote1,4/0.png")
                                        .frame(width: 128, height: 256)
                                    Text(DeviceType.remote.rawValue)
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
