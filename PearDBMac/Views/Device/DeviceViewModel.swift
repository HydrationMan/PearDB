//
//  DeviceViewModel.swift
//  PearDB
//
//  Created by Paras KCD on 16/2/25.
//

import Foundation
import SwiftUICore
@MainActor class DeviceViewModel: ObservableObject {
    private let appDbDownloader: AppleDBDownloader
    @Published var devices: [Device] = []
    @Published var searchedDevices: [Device] = []
    @Published var filter: DeviceType = .accessories
    @Published var isLoading: Bool = true
    
    init(appDbDownloader: AppleDBDownloader) {
        self.appDbDownloader = appDbDownloader
        Task {
            await self.initializeDownload()
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
        self.loadDeviceData()
    }
    
    private func loadDeviceData() {
        if let data = appDbDownloader.loadLocalJSON(named: "device_main") {
            do {
                let decodedDevices = try JSONDecoder().decode([Device].self, from: data)
                DispatchQueue.main.async {
                    self.devices = decodedDevices
                    self.isLoading = false
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
}
