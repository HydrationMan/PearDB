//
//  DeviceViewModel.swift
//  PearDB
//
//  Created by Paras KCD on 16/2/25.
//

import Foundation
import SwiftUICore
@MainActor class DeviceViewModel: ObservableObject {
    private let appDbDownloader: AppleDBDownloader = AppleDBDownloader.shared
    @Published var devices: [Device] = []
    @Published var deviceImages: [DeviceImages] = []
    @Published var selectedDeviceGroup: DeviceGroupType = DeviceGroupType.iOSDevices
    @Published var searchedDevices: [Device] = []
    @Published var filter: DeviceType = .accessories
    @Published var isLoading: Bool = true
    
    init() {
        Task {
            await self.initializeDownload()
            self.isLoading = false
        }
    }
    
    // MARK: Public Functions
    
    public func search(searchString: String) {
        if (!searchString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            self.searchedDevices = self.devices.filter { $0.name.lowercased().contains(searchString.lowercased())}
        } else {
            self.searchedDevices = []
        }
    }
    
    public func changeFilter(filter: DeviceType) {
        self.filter = filter
        switch filter {
        case .accessories:
            self.selectedDeviceGroup = .homeAndAccessories
        case .adapters:
            self.selectedDeviceGroup = .homeAndAccessories
        case .airPods:
            self.selectedDeviceGroup = .audio
        case .airPort:
            self.selectedDeviceGroup = .homeAndAccessories
        case .airTag:
            self.selectedDeviceGroup = .homeAndAccessories
        case .applePencil:
            self.selectedDeviceGroup = .inputs
        case .appleTV:
            self.selectedDeviceGroup = .homeAndAccessories
        case .appleWatch:
            self.selectedDeviceGroup = .homeAndAccessories
        case .audio:
            self.selectedDeviceGroup = .audio
        case .beatsEarbuds:
            self.selectedDeviceGroup = .audio
        case .beatsHeadphones:
            self.selectedDeviceGroup = .audio
        case .beatsSpeakers:
            self.selectedDeviceGroup = .audio
        case .beddit:
            self.selectedDeviceGroup = .homeAndAccessories
        case .bluetooth:
            self.selectedDeviceGroup = .homeAndAccessories
        case .cases:
            self.selectedDeviceGroup = .homeAndAccessories
        case .display:
            self.selectedDeviceGroup = .homeAndAccessories
        case .headset:
            self.selectedDeviceGroup = .homeAndAccessories
        case .homePod:
            self.selectedDeviceGroup = .audio
        case .keyboard:
            self.selectedDeviceGroup = .inputs
        case .macPro:
            self.selectedDeviceGroup = .macs
        case .macStudio:
            self.selectedDeviceGroup = .macs
        case .macMini:
            self.selectedDeviceGroup = .macs
        case .macBook:
            self.selectedDeviceGroup = .macs
        case .macBookAir:
            self.selectedDeviceGroup = .macs
        case .macBookPro:
            self.selectedDeviceGroup = .macs
        case .macintosh:
            self.selectedDeviceGroup = .macs
        case .mouse:
            self.selectedDeviceGroup = .inputs
        case .power:
            self.selectedDeviceGroup = .homeAndAccessories
        case .powerBook:
            self.selectedDeviceGroup = .macs
        case .powerMac:
            self.selectedDeviceGroup = .macs
        case .remote:
            self.selectedDeviceGroup = .inputs
        case .trackpad:
            self.selectedDeviceGroup = .inputs
        case .xserve:
            self.selectedDeviceGroup = .macs
        case .emac:
            self.selectedDeviceGroup = .macs
        case .ibook:
            self.selectedDeviceGroup = .macs
        case .iphone:
            self.selectedDeviceGroup = .iOSDevices
        case .imac:
            self.selectedDeviceGroup = .macs
        case .ipad:
            self.selectedDeviceGroup = .iOSDevices
        case .ipadAir:
            self.selectedDeviceGroup = .iOSDevices
        case .ipadPro:
            self.selectedDeviceGroup = .iOSDevices
        case .ipadMini:
            self.selectedDeviceGroup = .iOSDevices
        case .ipod:
            self.selectedDeviceGroup = .iPods
        case .ipodMini:
            self.selectedDeviceGroup = .iPods
        case .ipodNano:
            self.selectedDeviceGroup = .iPods
        case .ipodShuffle:
            self.selectedDeviceGroup = .iPods
        case .ipodTouch:
            self.selectedDeviceGroup = .iPods
        default:
            self.selectedDeviceGroup = .iOSDevices
        }
    }
    
    // MARK: Private Functions
    
    private func initializeDownload() async {
        do {
            try await self.appDbDownloader.downloadAllIfNeeded()
            if (appDbDownloader.isDownloading) {
                self.isLoading = true
            }
        } catch {
            print("❌ Error downloading device data: \(error)")
        }
        self.loadDeviceImages()
        self.loadDeviceData()
    }
    
    private func loadDeviceData() {
        if let data = appDbDownloader.loadLocalJSON(named: "device_main") {
            do {
                let decodedDevices = try JSONDecoder().decode([Device].self, from: data)
                DispatchQueue.main.async {
                    self.devices = decodedDevices.map({ device in
                        if let image = self.deviceImages.first(where: {$0.key == device.key}) {
                            if image.count > 0 {
                                let newDevice = device
                                image.index.forEach { imageIndex in
                                    let imageUrl = "https://img.appledb.dev/device@256/\(device.key)/\(imageIndex.idText).png"
                                    newDevice.imageUrl.append(imageUrl)
                                }
                                return newDevice
                            }
                        }
                        return device
                    })
                }
            } catch let DecodingError.typeMismatch(_, context) {
                print("❌ Type mismatch error: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")

                // Attempt to print the offending JSON section
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonArray = jsonObject as? [[String: Any]] {

                    // Print the specific object at the reported index
                    if let index = context.codingPath.first?.intValue, index < jsonArray.count {
                        print("❌ Offending JSON entry: \(jsonArray[index])")
                    }
                }
            } catch {
                print("❌Error decoding devices: \(error)")
            }
        } else {
            print("⚠️ No local device data found.")
        }
    }
    
    private func loadDeviceImages() {
        if let data = appDbDownloader.loadLocalJSON(named: "device_images") {
            do {
                let decodedDeviceImages = try JSONDecoder().decode([DeviceImages].self, from: data)
                DispatchQueue.main.async {
                    self.deviceImages = decodedDeviceImages
                }
            } catch let DecodingError.typeMismatch(_, context) {
                print("❌ Type mismatch error: \(context.debugDescription)")
                print("Coding Path: \(context.codingPath)")

                // Attempt to print the offending JSON section
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonArray = jsonObject as? [[String: Any]] {

                    // Print the specific object at the reported index
                    if let index = context.codingPath.first?.intValue, index < jsonArray.count {
                        print("❌ Offending JSON entry: \(jsonArray[index])")
                    }
                }
            } catch {
                print("❌Error decoding device images: \(error)")
            }
        } else {
            print("⚠️ No local device images data found.")
        }
    }
}
