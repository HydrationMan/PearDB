//
//  DatabaseViewModel.swift
//  PearDB
//
//  Created by Paras KCD on 1/3/25.
//

import Foundation
import SwiftUI
import CoreData

@MainActor class DatabaseViewModel: ObservableObject {
    private let moc: NSManagedObjectContext = DeviceEntryProvider.shared.viewContext
    private let appDbDownloader: AppleDBDownloader = AppleDBDownloader.shared
    @Published var storedEntries: [Entry] = []
    @Published var devices: [Device] = []
    @Published var images: [DeviceImages] = []
    @Published var firmwares: [Firmware] = []
    @Published var searchedDevices: [Device] = []
    @Published var isLoading: Bool = true
    @Published var selectedEntry: Entry? = nil
    
    init() {
        Task {
            await self.initializeDownload()
            await self.loadCoreData()
            self.isLoading = false
        }
    }
    
    public func reloadCoreData() async {
        self.isLoading = true
        await self.loadCoreData()
        self.isLoading = false
    }
    
    public func search(searchString: String) {
        if (!searchString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            self.searchedDevices = self.devices.filter {
                $0.name.lowercased().contains(searchString.lowercased())
            }
        } else {
            self.searchedDevices = []
        }
    }
    
    public func mapEntriesToDevices(entry: Entry) -> (Device?, Firmware?) {
        let device = self.devices.first { device in
            device.id == entry.key
        }
        let firmware = self.firmwares.first { firmware in
            firmware.key == entry.firmware
        }
        return (device, firmware)
    }
    
    public func deleteEntry(entry: Entry) async {
        moc.delete(entry)
        try? moc.save()
        await self.reloadCoreData()
    }
    
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
        self.loadFirmwareData()
    }
    
    private func loadDeviceData() {
        if let data = appDbDownloader.loadLocalJSON(named: "device_main") {
            do {
                let decodedDevices = try JSONDecoder().decode([Device].self, from: data)
                DispatchQueue.main.async {
                    self.devices = decodedDevices.filter({ $0.deviceGroup == .iOSDevices || $0.deviceGroup == .macs || ($0.deviceGroup == .homeAndAccessories && !($0.deviceType == .accessories || $0.deviceType == .beddit || $0.deviceType == .cases || $0.deviceType == .adapters || $0.deviceType == .power)) || $0.deviceGroup == .audio || $0.deviceGroup == .iPods || $0.deviceGroup == .inputs}).map({ device in
                        if let image = self.images.first(where: {$0.key == device.key}) {
                            if image.count > 0 {
                                let newDevice = device
                                image.index.forEach { imageIndex in
                                    let imageUrl = "https://img.appledb.dev/device@256/\(device.effectiveImageKey)/\(imageIndex.idText).png"
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
    
    private func loadFirmwareData() {
        if let data = appDbDownloader.loadLocalJSON(named: "ios_main") {
            do {
                let decodedFirmwares = try JSONDecoder().decode([Firmware].self, from: data)
                DispatchQueue.main.async {
                    self.firmwares = decodedFirmwares
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
            print("⚠️ No local firmware data found.")
        }
    }
    
    private func loadCoreData() async {
        self.storedEntries = []
        let fetchRequest = Entry.fetchRequest() as! NSFetchRequest<Entry>
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Entry.isMain, ascending: true)]
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchResult -> Void in
            if let results = fetchResult.finalResult {
                self.storedEntries = results
            } else {
                print("⚠️ No core data found.")
            }
        }
        
        do {
            _ = try moc.execute(asyncFetchRequest)
        } catch {
            print("❌Error fetching core data: \(error)")
        }
    }
    
    private func loadDeviceImages() {
        if let data = appDbDownloader.loadLocalJSON(named: "device_images") {
            do {
                let decodedDeviceImages = try JSONDecoder().decode([DeviceImages].self, from: data)
                DispatchQueue.main.async {
                    self.images = decodedDeviceImages
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

