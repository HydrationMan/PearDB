//
//  DeviceView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct DeviceView: View {
    @State var selectedFilter: DeviceType = .iphone
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @State var search: String = ""
    
    var body: some View {
        ZStack {
            #if os(macOS)
                Rectangle.semiOpaqueWindow().padding(-1)
            #endif
            NavigationStack {
                VStack {
                    HeaderView(title: "Devices") {
                        HeaderMenu()
                    } searchable: { search in
                        deviceViewModel.search(searchString: search)
                    }
                    
                    if deviceViewModel.isLoading {
                        ProgressView("Downloading Device Data…")
                            .progressViewStyle(.circular)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        #if os(iOS)
                        Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { search in
                            deviceViewModel.search(searchString: search)
                        } onCancel: {
                            search = ""
                            deviceViewModel.search(searchString: "")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)

                        DeviceScrollView()
                            .environmentObject(deviceViewModel)
                            .navigationTitle(deviceViewModel.selectedDeviceGroup.rawValue)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    HeaderMenu()
                                }
                            }
                        #else
                        DeviceScrollView()
                            .environmentObject(deviceViewModel)
                        #endif
                    }
                }
            }
            .navigationTitle(deviceViewModel.selectedDeviceGroup.rawValue)
            .onAppear {
                deviceViewModel.filter = selectedFilter
            }
        }
    }
}

struct DeviceScrollView: View {
    let columns = [GridItem(.adaptive(minimum: 300))]
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                if (!deviceViewModel.searchedDevices.isEmpty) {
                    ForEach(
                        deviceViewModel.searchedDevices.lazy
                            .filter { $0.deviceType == deviceViewModel.filter }
                            .sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending }),
                        id: \.id
                    ) { device in
                        DeviceItemView(device: device)
                    }
                } else if (!deviceViewModel.devices.isEmpty) {
                    ForEach(
                        deviceViewModel.devices.lazy
                            .filter { $0.deviceType == deviceViewModel.filter }
                            .sorted { $0.key.localizedStandardCompare($1.key) == .orderedAscending },
                        id: \.id
                    ) { device in
                        DeviceItemView(device: device)
                    }
                }
                #if os(macOS)
                Color.clear.padding(16)
                Color.clear.padding(16)
                Color.clear.padding(16)
                #endif
            }
        }
        .padding(.horizontal, 16)
    }
}

struct HeaderMenu: View {
    let deviceTypes: [DeviceType] = DeviceType.allCases
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        Menu {
            ForEach(Array(deviceTypes.enumerated()), id: \.offset) { offset, deviceType in
                Button(deviceType.rawValue) {
                    deviceViewModel.changeFilter(filter: deviceType)
                }
            }
        } label: {
            Label {
                Text(deviceViewModel.filter.rawValue)
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .containerShape(RoundedRectangle(cornerRadius: 99))
        }
        .frame(maxWidth: 128)
        .menuStyle(BorderlessButtonMenuStyle())
        .padding(8)
        .background(.thickMaterial)
        .cornerRadius(99)
        .overlay {
            #if os(macOS)
            RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
            #else
            RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
            #endif
        }
    }
}
