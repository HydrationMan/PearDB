//
//  DatabaseView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
//

import SwiftUI

struct DatabaseView: View {
    @State var search: String = ""
    @State private var isShowingNewDevice = false
    
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
            
            NavigationStack {
                VStack {
                    HeaderView(title: "My Devices") {
                        AddDeviceButtonView(isLoading: dbViewModel.isLoading, isDeviceAlreadySaved: false, fromDB: false) {
                            isShowingNewDevice.toggle()
                        }
                    }
                    
                    if dbViewModel.isLoading {
                        ProgressView("Downloading your stored devices…")
                            .progressViewStyle(.circular)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        #if os(iOS)
                            Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { search in
                                
                            } onCancel: {
                                search = ""
                                
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            
                            DatabaseScrollView()
                                .environmentObject(dbViewModel)
                                .navigationTitle("My Devices")
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        AddDeviceButtonView(isLoading: dbViewModel.isLoading, isDeviceAlreadySaved: false, fromDB: false) {
                                            isShowingNewDevice.toggle()
                                        }
                                    }
                                }
                        #else
                            DatabaseScrollView()
                                .environmentObject(dbViewModel)
                        #endif
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewDevice) {
            #if os(macOS)
                NewDeviceView()
                    .environmentObject(dbViewModel)
                    .frame(width: 768)
                    .onDisappear {
                        Task {
                            await dbViewModel.reloadCoreData()
                        }
                    }
            #else
                NewDeviceView()
                    .environmentObject(dbViewModel)
                    .onDisappear {
                        Task {
                            await dbViewModel.reloadCoreData()
                        }
                    }
            #endif
        }
    }
}

struct DatabaseScrollView: View {
    let columns = [GridItem(.adaptive(minimum: 300))]
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    
    var body: some View {
        ScrollView {
            if !dbViewModel.devices.isEmpty {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    if (!dbViewModel.storedEntries.isEmpty) {
                        ForEach(dbViewModel.storedEntries, id: \.key) { entry in
                            let map = dbViewModel.mapEntriesToDevices(entry: entry)
                            let firmware = map.1
                            if let device = map.0 {
                                DeviceItemView(device: device, entry: entry, firmware: firmware)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            Task {
                                                await dbViewModel.deleteEntry(entry: entry)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            Task {
                await dbViewModel.reloadCoreData()
            }
        }
    }
}
