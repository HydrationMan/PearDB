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
    private var downloads: [URL: Download] = [:]
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
        
        return loadIPSWData(build, deviceKey)?.signed
    }
    
    public func downloadFirmware(deviceKey: String, firmware: Firmware) async {
        guard let build = firmware.build else { return }
        do {
            try await self.appDbDownloader.downloadIPSWIfNeeded(buildid: build, identifier: deviceKey)
            if (appDbDownloader.isDownloading) {
                self.isFirmwareLoading.append(deviceKey)
            }
        } catch {
            print("❌ Error downloading device data: \(error)")
            return
        }
        if let ipswFirmware = loadIPSWData(build, deviceKey) {
            guard let urlString = ipswFirmware.url
            else {
                print("⚠️ No IPSW URL found")
                return
            }
            guard let url = URL(string: urlString)
            else {
                print("❌ Error parsing url to URL Object")
                return
            }
            guard downloads[url] == nil, !firmware.isDownloadCompleted else { return }
            let download = if case let .canceled(data) = firmware.state {
                Download(resumeData: data)
            } else {
                Download(url: url)
            }
            downloads[url] = download
            download.start()
            
            for await event in download.events {
                process(event, for: firmware)
            }
            
            downloads[url] = nil
        }
        
    }
    
    private func loadIPSWData(_ build: String, _ deviceKey: String) -> IpswFirmware? {
        if let data = appDbDownloader.loadLocalJSON(named: "\(deviceKey)_\(build)") {
            do {
                let decodedIPSWFirmware = try JSONDecoder().decode(IpswFirmware.self, from: data)
                if (self.isFirmwareLoading.contains {$0 == deviceKey}) {
                    self.isFirmwareLoading.remove(at: self.isFirmwareLoading.firstIndex(of: deviceKey)!)
                }
                return decodedIPSWFirmware
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

private extension DeviceFirmwaresViewModel {
    func process(_ event: Download.Event, for firmware: Firmware) {
        switch event {
        case let .progress(current, total):
            print(current, total)
        case let .completed(url):
            saveFile(for: firmware, at: url)
        default:
            return
        }
    }
    
    func saveFile(for firmware: Firmware, at url: URL) {
        let filemanager = FileManager.default
        do {
            var downloadDirectory = filemanager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            downloadDirectory = downloadDirectory.appendingPathComponent("PearDBDownloads")
            if !filemanager.fileExists(atPath: downloadDirectory.path()) {
                try? filemanager.createDirectory(at: downloadDirectory, withIntermediateDirectories: true)
            }
            downloadDirectory = downloadDirectory.appendingPathComponent("\(firmware.key).ipsw")
            try? filemanager.moveItem(at: url, to: downloadDirectory)
            print("Downloaded temp file \(url) saved to \(downloadDirectory)")
        }
    }
}
