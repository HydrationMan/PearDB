//
//  SettingsView.swift
//  PearDB
//
//  Created by Kane Parkinson on 09/02/2025.
//

import SwiftUI
import CoreData
import Foundation
import CoreSpotlight

struct SettingsView: View {
    @State private var isPurging = false
    @State private var isRedownloading = false
    
    let sampleData = ["iPhone16,2", "Mac14,2", "Watch6,18"]
    
    var body: some View {
        Form {
            Section(header: Text("Debug")) {
                Button("Purge Downloaded Data") {
                    isPurging = true
                }
                .foregroundColor(.red)
                .alert(isPresented: $isPurging) {
                    Alert(
                        title: Text("Purge Downloaded Data"),
                        message: Text("Are you sure? This will delete all local jsons and trigger a redownload on subsequent view access!"),
                        primaryButton: .destructive(Text("Purge")) {
                            purgeData()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            Section(header: Text("Git Info for Build")) {
                Text("Commit Hash: ") +
                Text(GitCommitInfo.hash)
                    .foregroundColor(.yellow)
                    .bold()

                Text("References: ") +
                Text("HEAD")
                    .foregroundColor(.blue) +
                Text(" -> ") +
                Text("0.2.0")
                    .foregroundColor(.green) +
                Text(", ") +
                Text("origin/HEAD")
                    .foregroundColor(.red) +
                Text(", ") +
                Text("origin/0.2.0")
                    .foregroundColor(.red)

                Text("Message: ") +
                Text(GitCommitInfo.message)
                    .italic()
            }
        }
    }
    
    func indexData() {
        var searchableItems = [CSSearchableItem]()
        sampleData.forEach {
            let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
            attributeSet.displayName = $0.description
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: nil, domainIdentifier: "sample", attributeSet: attributeSet)
            searchableItems.append(searchableItem)
        }
        CSSearchableIndex.default().indexSearchableItems(searchableItems)
    }

    private func purgeData() {
        isPurging = true
        Task {
            do {
                try await AppleDBDownloader.shared.purgeData()
                print("✅ Data purged successfully")
            } catch {
                print("❌ Error purging data: \(error)")
            }
            isPurging = false
        }
    }

    private func redownloadData() {
        isRedownloading = true
        Task {
            do {
                try await AppleDBDownloader.shared.downloadAllIfNeeded()
                print("✅ Data redownloaded successfully")
            } catch {
                print("❌ Error redownloading data: \(error)")
            }
            isRedownloading = false
        }
    }
}

//func containerPath() -> String {
//    if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
//        return "containerPath:\(path)"
//    } else {
//        return "path not found."
//    }
//}
//
//func listDocumentsDirectorySubpaths() {
//    let fileManager = FileManager.default
//    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//        do {
//            let subpaths = try fileManager.subpathsOfDirectory(atPath: documentsURL.path)
//            print("Recursive Contents of Documents Directory:")
//            for path in subpaths {
//                print("- \(path)")
//            }
//        } catch {
//            print("Failed to list subpaths with error: \(error)")
//        }
//    }
//}
