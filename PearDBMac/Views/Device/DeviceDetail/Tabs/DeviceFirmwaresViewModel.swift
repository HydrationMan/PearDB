//
//  DeviceFirmwaresViewModel.swift
//  PearDB
//
//  Created by Paras KCD on 24/2/25.
//

import Foundation
import SwiftUICore
@MainActor class DeviceFirmwaresViewModel: ObservableObject {
    private let appDbDownloader: AppleDBDownloader = AppleDBDownloader.shared
    
    @Published var firmwares: [Firmware] = []
    @Published var selectedFirmwares: [Firmware] = []
    @Published var betaFirmwares: [Firmware] = []
    @Published var rcFirmwares: [Firmware] = []
    @Published var isLoading: Bool = true
    @Published var isFirmwareLoading: [String] = []
    
    init() {
        Task {
            await self.initializeDownload()
            self.isLoading = false
        }
    }
    
    public func filterFirmwares(device: Device) {
        let filteredFirmwares = self.firmwares.filter { $0.deviceMap.contains { $0 == device.key } }
        if (!filteredFirmwares.isEmpty) {
            self.selectedFirmwares = filteredFirmwares.filter({ $0.rc == false && $0.beta == false }).sorted(by: { $0.version.localizedStandardCompare($1.version) == .orderedDescending })
            self.betaFirmwares = filteredFirmwares.filter({ $0.beta == true && $0.rc == false }).sorted(by: { $0.version.localizedStandardCompare($1.version) == .orderedDescending })
            self.rcFirmwares = filteredFirmwares.filter({ $0.beta == false && $0.rc == true }).sorted(by: { $0.version.localizedStandardCompare($1.version) == .orderedDescending })
        } else {
            print("⚠️ No Firmwares found")
        }
    }
    
    public func checkIfSigned(build: String, deviceKey: String) async -> Bool? {
        do {
            try await self.appDbDownloader.downloadIPSWIfNeeded(buildid: build, identifier: deviceKey)
            if (appDbDownloader.isDownloading) {
                self.isFirmwareLoading.append(deviceKey)
            }
        } catch {
            print("❌ Error downloading device data: \(error)")
            return nil
        }
        
        return loadIPSWData(build, deviceKey)
    }
    
    private func loadIPSWData(_ build: String, _ deviceKey: String) -> Bool? {
        if let data = appDbDownloader.loadLocalJSON(named: "\(deviceKey)_\(build)") {
            do {
                let decodedIPSWFirmware = try JSONDecoder().decode(IpswFirmware.self, from: data)
                if (self.isFirmwareLoading.contains {$0 == deviceKey}) {
                    self.isFirmwareLoading.remove(at: self.isFirmwareLoading.firstIndex(of: deviceKey)!)
                }
                return decodedIPSWFirmware.signed
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
        }
        
        return nil
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
        self.loadFirmwareData()
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
}
