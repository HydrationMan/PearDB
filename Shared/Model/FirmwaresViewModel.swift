//
//  FirmwaresViewModel.swift
//  PearDB
//
//  Created by Paras KCD on 22/3/25.
//

import Foundation
import SwiftUI

@MainActor
class FirmwaresViewModel: ObservableObject {
    private let appDbDownloader = AppleDBDownloader.shared
    
    private var page = 0
    private var pageSize = 25
    private let loadMoreDelay: Double = 1.5
    
    @Published var firmwares: [Firmware] = []
    @Published var filteredFirmwares: [Firmware] = []
    @Published var paginatedFirmwares: [Firmware] = []
    @Published var isLoading: Bool = true
    @Published var searchedFirmwares: [Firmware] = []
    @Published var isLoadMore = true
    @Published var filter: FirmwareTypes = .iOS
    @Published var selectedFirmwareType: FirmwareType = .release
    
    init() {
        #if os(macOS)
        self.filter = .macOS
        #elseif os(visionOS)
        self.filter = .visionOS
        #elseif os(watchOS)
        self.filter = .watchOS
        #elseif os(tvOS)
        self.filter = .tvOS
        #endif
        Task {
            await self.initializeDownload()
            self.isLoading = false
        }
    }
    
    public func search(searchString: String) {
        if (!searchString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            self.searchedFirmwares = self.filteredFirmwares.filter {
                $0.version.lowercased()
                    .contains(searchString.lowercased())
            }
            
        } else {
            self.searchedFirmwares = []
        }
    }
    
    public func loadMoreIfNeeded(currentItem: Firmware?) {
        if currentItem == nil {
            self.isLoadMore = true
            DispatchQueue.main.async {
                self.filteredFirmwares = self.firmwares.filter({ $0.releasedDateType != nil && $0.firmwareType == self.filter && $0.firmwareReleaseType == self.selectedFirmwareType }).sorted(by: { self.sortByDescendingDate($0, $1) })
                self.loadMore()
            }
        }
        guard !isLoadMore, currentItem?.id == self.paginatedFirmwares.last?.id else { return }
        self.loadMore()
    }
    
    public func changeFilter(filter: FirmwareTypes) {
        self.page = 0
        self.filter = filter
        self.filteredFirmwares = self.firmwares.filter({ $0.releasedDateType != nil && $0.firmwareType == self.filter && $0.firmwareReleaseType == self.selectedFirmwareType }).sorted(by: { self.sortByDescendingDate($0, $1) })
        self.loadMore()
    }
    
    public func changeFirmwareReleaseType(releaseType: FirmwareType) {
        self.page = 0
        self.selectedFirmwareType = releaseType
        self.filteredFirmwares = self.firmwares.filter({ $0.releasedDateType != nil && $0.firmwareType == self.filter && $0.firmwareReleaseType == releaseType }).sorted(by: { self.sortByDescendingDate($0, $1) })
        self.loadMore()
    }
    
    // MARK: Private Functions
    
    private func initializeDownload() async {
        do {
            try await self.appDbDownloader.downloadAllIfNeeded()
            if (appDbDownloader.isDownloading) {
                self.isLoading = true
            }
        } catch {
            print("❌ Error downloading firmware data: \(error)")
        }
        self.loadFirmwareData()
    }
    
    private func loadMore() {
        self.isLoadMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + loadMoreDelay) {
            var nextItems: [Firmware] = []
            if self.page > 0 {
                nextItems = Array(self.filteredFirmwares.dropFirst(self.pageSize * self.page).prefix(self.pageSize))
            } else {
                nextItems = Array(self.filteredFirmwares.prefix(self.pageSize))
            }
            self.paginatedFirmwares.append(contentsOf: nextItems)
            self.isLoadMore = false
            self.page += 1
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
                print("❌Error decoding firmwares: \(error)")
            }
        }
    }
    
    private func sortByDescendingDate(_ a: Firmware, _ b: Firmware) -> Bool {
        guard let aReleaseDate = a.releasedDateType else { return false }
        guard let bReleaseDate = b.releasedDateType else { return false }
        return bReleaseDate < aReleaseDate
    }
    
    private func sortByName(_ a: Firmware, _ b: Firmware) -> Bool {
        return a.key.localizedStandardCompare(b.key) == .orderedAscending
    }
}
