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
            self.selectedFirmwares = filteredFirmwares.filter({ $0.firmwareReleaseType == .release && $0.sources != nil }).sorted(by: { sortByDescendingDateFirmware($0, $1) })
            self.betaFirmwares = filteredFirmwares.filter({ $0.firmwareReleaseType == .beta && $0.sources != nil }).sorted(by: { sortByDescendingDateFirmware($0, $1) })
            self.rcFirmwares = filteredFirmwares.filter({ $0.firmwareReleaseType == .rc && $0.sources != nil }).sorted(by: { sortByDescendingDateFirmware($0, $1) })
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
    
    public func downloadFirmware(deviceKey: String, firmware: Firmware) async throws {
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
            guard let url = getIPSWDownloadUrl(urlString: ipswFirmware.url)
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
            changeFirmwareDownloadState(for: firmware, state: .dowloading)
            for await event in download.events {
                process(event, for: firmware, deviceKey: deviceKey)
            }
            
            downloads[url] = nil
        }
    }
    
    public func cancelDownload(for firmware: Firmware, deviceKey: String) {
        guard let build = firmware.build else { return }
        if let ipswFirmware = loadIPSWData(build, deviceKey) {
            guard let url = getIPSWDownloadUrl(urlString: ipswFirmware.url)
            else {
                print("❌ Error parsing url to URL Object")
                return
            }
            downloads[url]?.cancel()
            changeFirmwareDownloadState(for: firmware, state: .idle)
        }
    }
    
    private func changeFirmwareDownloadState(for firmware: Firmware, state: Firmware.State) {
        self.selectedFirmwares = self.selectedFirmwares.map({ f in
            if f.key == firmware.key {
                let newFirmware = f
                newFirmware.state = state
                return newFirmware
            }
            
            return f
        })
    }
    
    private func getIPSWDownloadUrl(urlString: String?) -> URL? {
        guard let urlString = urlString
        else {
            print("⚠️ No IPSW URL found")
            return nil
        }
        
        return URL(string: urlString)
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
    
    private func sortByDescendingDateFirmware(_ a: Firmware, _ b: Firmware) -> Bool {
        guard let aReleaseDate = a.releasedDateType else { return false }
        guard let bReleaseDate = b.releasedDateType else { return false }
        return bReleaseDate < aReleaseDate
    }
    
    private func sortByNameFirmware(_ a: Firmware, _ b: Firmware) -> Bool {
        return a.key.localizedStandardCompare(b.key) == .orderedAscending
    }
    
    private func sortByDescendingDateDevice(_ a: Device, _ b: Device) -> Bool {
        guard let aReleaseDate = a.releasedDateType else { return false }
        guard let bReleaseDate = b.releasedDateType else { return false }
        return bReleaseDate < aReleaseDate
    }
    
    private func sortByNameDevice(_ a: Device, _ b: Device) -> Bool {
        return a.key.localizedStandardCompare(b.key) == .orderedAscending
    }
}

private extension DeviceFirmwaresViewModel {
    func process(_ event: Download.Event, for firmware: Firmware, deviceKey: String) {
        switch event {
        case let .progress(current, total):
            updateFirmware(firmware, currentBytes: current, totalBytes: total)
        case let .completed(url):
            saveFile(for: firmware, at: url, deviceKey: deviceKey)
        default:
            return
        }
    }
    
    func updateFirmware(_ firmware: Firmware, currentBytes: Int64, totalBytes: Int64) {
        self.selectedFirmwares = self.selectedFirmwares.map({ f in
            if f.key == firmware.key {
                let newFirmware = f
                newFirmware.update(currentBytes: currentBytes, totalBytes: totalBytes)
                return newFirmware
            }
            
            return f
        })
    }
    
    func saveFile(for firmware: Firmware, at url: URL, deviceKey: String) {
        let filemanager = FileManager.default
        do {
            var downloadDirectory = filemanager.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            downloadDirectory = downloadDirectory.appendingPathComponent("PearDBDownloads")
            if !filemanager.fileExists(atPath: downloadDirectory.path()) {
                try? filemanager.createDirectory(at: downloadDirectory, withIntermediateDirectories: true)
            }
            downloadDirectory = downloadDirectory.appendingPathComponent("\(deviceKey)_\(firmware.version)\(firmware.build != nil ? "_\(firmware.build!)" : "")\(firmware.restoreVersion != nil ? "_Restore" : "").ipsw")
            try? filemanager.moveItem(at: url, to: downloadDirectory)
            print("✅ Successfully downloaded temp file: \(url) saved to: \(downloadDirectory)")
        }
    }
}
