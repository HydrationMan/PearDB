//
//  ConfirmFromAppleDBView.swift
//  PearDB
//
//  Created by Kane Parkinson on 18/08/2024.
//

import SwiftUI

struct ConfirmFromAppleDBView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: EditHardwareViewModel
    @EnvironmentObject var DBModel: appleDBPoll
    @StateObject private var fwModel = firmwareModel()
    @State private var showAdditionalInfoView: Bool = false
    
    var body: some View {
        if DBModel.error == true {
            RetrieveErrorView(vm: vm)
        } else {
            if showAdditionalInfoView {
                withAnimation(.easeInOut) {
                    AdditionalInformationView(vm: vm)
                        .environmentObject(fwModel)
                }
            } else {
                VStack {
                    Text("Confirm your device.")
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 20)
                    AsyncCachedImage(
                        url: URL(string: "https://img.appledb.dev/device@main/\(DBModel.identifier)/0.avif"),
                        failurePlaceholder: "xmark.octagon",
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        },
                        placeholder: {
                            ProgressView()
                                .frame(width: 200, height: 200)
                        }
                    )
                    Text("\(DBModel.name)")
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 50)
                                    .frame(width: 100)
                                    .foregroundStyle(Color.red)
                                Text("Cancel")
                                    .foregroundStyle(Color.white)
                            }
                        })
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showAdditionalInfoView = true
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 50)
                                    .frame(width: 100)
                                    .foregroundStyle(Color.green)
                                Text("Proceed")
                                    .foregroundStyle(Color.white)
                            }
                        })
                    }
                }
            }
        }
    }
}

struct FirmwareEntry: Codable, Hashable {
    let osStr: String
    let version: String
    let build: String?
    let internalVersion: Bool? // Updated property name
    let beta: Bool?
    let deviceMap: [String]
    let rc: Bool? // Added property for RC builds
    
    enum CodingKeys: String, CodingKey {
        case osStr = "osStr"
        case version
        case build
        case internalVersion = "internal" // Updated key
        case beta
        case deviceMap
        case rc // Added key for RC builds
    }
}

struct AdditionalInformationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: EditHardwareViewModel
    @EnvironmentObject var DBModel: appleDBPoll
    @StateObject private var fwModel = firmwareModel()
    @State private var firmwareEntries: [FirmwareEntry] = []
    @State private var isLoading = false
    @State private var showReleaseOnly = false
    @State private var showRCBuilds = false
    @State private var selectedEntry: FirmwareEntry?
    @State private var showAddToHardwareView: Bool = false
    @State private var dataFetched = false // New state for checking if data has been fetched
    @State private var returnToCreateHardware = false

    var body: some View {
        VStack {
            if isLoading && !dataFetched {
                ProgressView()
                Text("Talking to AppleDB...")
                    .font(.largeTitle.bold())
                Text("This can take a bit, hang tight.")
                    .font(.callout)
            } else {
                if showAddToHardwareView {
                    AddToHardwareView(vm: vm)
                        .environmentObject(fwModel)
                } else {
                    if returnToCreateHardware {
                        CreateHardwareView(vm: vm)
                    } else {
                        Picker("Select Firmware", selection: $selectedEntry) {
                            ForEach(firmwareEntries, id: \.self) { entry in
                                Text("\(entry.version) - \(entry.build ?? "Unknown")")
                                    .tag(entry as FirmwareEntry?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Toggle("Show Release Versions Only", isOn: $showReleaseOnly)
                            .onChange(of: showReleaseOnly) { _ in
                                fetchFirmwareData()
                            }
                        
                        Toggle("Show RC Builds", isOn: $showRCBuilds)
                            .onChange(of: showRCBuilds) { _ in
                                fetchFirmwareData()
                            }
                        
                        if let selected = selectedEntry {
                            VStack(alignment: .leading) {
                                Text("Selected Firmware Details")
                                    .font(.headline)
                                Text("OS: \(selected.osStr)")
                                Text("Version: \(selected.version)")
                                Text("Build: \(selected.build ?? "Unknown")")
                                Text("Internal Version: \(selected.internalVersion == true ? "Yes" : "No")")
                                Text("Beta: \(selected.beta == true ? "Yes" : "No")")
                                Text("RC Build: \(selected.rc == true ? "Yes" : "No")")
                                HStack {
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            returnToCreateHardware = true
                                        }
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(height: 50)
                                                .frame(width: 100)
                                                .foregroundStyle(Color.red)
                                            Text("Cancel")
                                                .foregroundStyle(Color.white)
                                        }
                                    })
                                    Button(action: {
                                        withAnimation(.easeInOut) {
                                            showAddToHardwareView = true
                                        }
                                        if selected.beta == true {
                                            fwModel.buildBeta = selected.beta ?? false
                                        }
                                        if selected.internalVersion == true {
                                            fwModel.buildInternal = selected.internalVersion ?? false
                                        }
                                        fwModel.version = selected.version
                                        fwModel.build = selected.build ?? "Unknown"
                                        fwModel.osStr = selected.osStr
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(height: 50)
                                                .frame(width: 100)
                                                .foregroundStyle(Color.green)
                                            Text("Proceed")
                                                .foregroundStyle(Color.white)
                                        }
                                    })
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            if !dataFetched {
                fetchFirmwareData()
            }
        }
    }

    func fetchFirmwareData() {
        isLoading = true
        guard let url = URL(string: "https://api.appledb.dev/ios/main.json") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([FirmwareEntry].self, from: data)

                    let filteredEntries = decodedData.filter { entry in
                        let isForDevice = entry.deviceMap.contains(DBModel.identifier)
                        let isReleaseVersion = entry.beta == false
                        let isNotInternalVersion = entry.internalVersion != true
                        let isNotRCBuild = entry.rc != true

                        return isForDevice &&
                            (!showReleaseOnly || isReleaseVersion) &&
                            (showRCBuilds || isNotRCBuild) &&
                            isNotInternalVersion
                    }

                    DispatchQueue.main.async {
                        self.firmwareEntries = filteredEntries.sorted {
                            sortBuildNumbers($0.build, $1.build)
                        }
                        self.updateInitialSelection()
                        withAnimation(.easeInOut) {
                            self.isLoading = false
                            self.dataFetched = true // Mark data as fetched
                        }
                    }
                } catch {
                    print("fetchFirmwareData; Error decoding JSON: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }

     // Function to sort build numbers
     private func sortBuildNumbers(_ build1: String?, _ build2: String?) -> Bool {
         guard let build1 = build1, let build2 = build2 else {
             return build1 != nil // nil should come last
         }
         
         // Implement sorting logic based on build number format
         return build1.compare(build2, options: .numeric) == .orderedDescending
     }

     // Function to update the initial picker selection
     private func updateInitialSelection() {
         if let firstEntry = firmwareEntries.first {
             self.selectedEntry = firstEntry
         } else {
             self.selectedEntry = nil
         }
     }
     
     // Function to load selected firmware from UserDefaults
     private func loadSelectedFirmware() {
         if let savedFirmware = UserDefaults.standard.data(forKey: "selectedFirmware") {
             let decoder = JSONDecoder()
             if let loadedFirmware = try? decoder.decode(FirmwareEntry.self, from: savedFirmware) {
                 self.selectedEntry = loadedFirmware
             }
         }
     }
 }
