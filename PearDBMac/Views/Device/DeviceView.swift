//
//  DeviceView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct DeviceView: View {
    let columns = [GridItem(.adaptive(minimum: 300))]
    @State var selectedFilter: DeviceType = .iphone
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            NavigationStack {
                VStack {
                    HeaderView(title: "Devices") { search in
                        deviceViewModel.search(searchString: search)
                    } applyFilter: { filter in
                        deviceViewModel.changeFilter(filter: filter)
                    }
                    
                    if deviceViewModel.isLoading {
                        ProgressView("Downloading Device Data…")
                            .progressViewStyle(.circular)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        ScrollView {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                                if (!deviceViewModel.searchedDevices.isEmpty) {
                                    ForEach(
                                        deviceViewModel.searchedDevices.lazy
                                            .filter { $0.deviceType == deviceViewModel.filter }
                                            .sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending }),
                                        id: \.id
                                    ) { device in
                                        DeviceItemView(device: device)
                                    }
                                } else if (!deviceViewModel.devices.isEmpty) {
                                    ForEach(
                                        deviceViewModel.devices.lazy
                                            .filter { $0.deviceType == deviceViewModel.filter }
                                            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending },
                                        id: \.id
                                    ) { device in
                                        DeviceItemView(device: device)
                                    }
                                }
                                Color.clear.padding(16)
                                Color.clear.padding(16)
                                Color.clear.padding(16)
                            }
                        }
                        .padding(.horizontal, 16)
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
