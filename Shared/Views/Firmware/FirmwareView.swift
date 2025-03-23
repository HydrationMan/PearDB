//
//  FirmwareView.swift
//  PearDB
//
//  Created by Paras KCD on 22/3/25.
//

import SwiftUI

struct FirmwareView: View {
    @FocusState private var isReleaseTypeMenuFocus: Bool
    @FocusState private var isFirmwareTypeMenuFocus: Bool
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    @State var search: String = ""
    
    var body: some View {
        ZStack {
        #if os(macOS)
            Rectangle.semiOpaqueWindow().padding(-1)
        #endif
            NavigationStack {
                HeaderView(title: "Firmwares") {
                    HStack {
                        FirmwareReleaseTypeMenu(focus: $isReleaseTypeMenuFocus)
                            .focused($isReleaseTypeMenuFocus)
                            .environmentObject(firmwaresViewModel)
                        FirmwareTypeMenu(focus: $isFirmwareTypeMenuFocus)
                            .focused($isFirmwareTypeMenuFocus)
                            .environmentObject(firmwaresViewModel)
                    }
                } searchable: { search in
                    firmwaresViewModel.search(searchString: search)
                }
                
                if firmwaresViewModel.isLoading || (firmwaresViewModel.isLoadMore && firmwaresViewModel.paginatedFirmwares.isEmpty)   {
                    ProgressView("Downloading Firmware Data…")
                        .progressViewStyle(.circular)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    #if os(iOS)
                    Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { search in
                        firmwaresViewModel.search(searchString: search)
                    } onCancel: {
                        search = ""
                        firmwaresViewModel.search(searchString: "")
                    }
                    .padding(.horizontal)
                    
                    Picker("", selection: $firmwaresViewModel.selectedFirmwareType) {
                        ForEach(FirmwareType.allCases, id: \.rawValue) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .onChange(of: firmwaresViewModel.selectedFirmwareType) { oldValue, newValue in
                        if oldValue != newValue {
                            firmwaresViewModel.isLoadMore = true
                            firmwaresViewModel.paginatedFirmwares = []
                            firmwaresViewModel.changeFirmwareReleaseType(releaseType: newValue)
                        }
                    }
                    
                    FirmwareScrollView()
                        .environmentObject(firmwaresViewModel)
                        .navigationTitle("Firmwares")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                FirmwareTypeMenu(focus: $isFirmwareTypeMenuFocus)
                                    .focused($isFirmwareTypeMenuFocus)
                                    .environmentObject(firmwaresViewModel)
                            }
                        }
                    #else
                    FirmwareScrollView()
                        .environmentObject(firmwaresViewModel)
                        .environmentObject(deviceViewModel)
                    #endif
                }
            }
            .onAppear {
                firmwaresViewModel.loadMoreIfNeeded(currentItem: nil)
            }
        }
    }
}

struct FirmwareScrollView: View {
    let columns = [GridItem(.adaptive(minimum: 500))]
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        ScrollView {
            FirmwareGridListView()
        }
        #if os(tvOS)
        .padding(0)
        #else
        .padding(.horizontal, 16)
        #endif
    }
}

struct FirmwareGridListView: View {
    #if os(tvOS)
    let columns = [GridItem(.adaptive(minimum: 800))]
    #else
    let columns = [GridItem(.adaptive(minimum: 500))]
    #endif
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
            if !firmwaresViewModel.searchedFirmwares.isEmpty {
                ForEach(firmwaresViewModel.searchedFirmwares.lazy, id: \.id) { firmware in
                    FirmwareItemView(firmware: firmware)
                        .environmentObject(deviceViewModel)
                    #if os(tvOS)
                        .frame(width: 800, height: 150)
                    #endif
                }
            } else if !firmwaresViewModel.paginatedFirmwares.isEmpty {
                ForEach(firmwaresViewModel.paginatedFirmwares.lazy, id: \.id) { firmware in
                    FirmwareItemView(firmware: firmware)
                        .environmentObject(deviceViewModel)
                    #if os(tvOS)
                        .frame(width: 800, height: 150)
                    #endif
                        .onAppear {
                            firmwaresViewModel.loadMoreIfNeeded(currentItem: firmware)
                        }
                }
            }
            #if os(macOS)
            if !firmwaresViewModel.isLoadMore {
                Color.clear.padding(16)
                Color.clear.padding(16)
                Color.clear.padding(16)
            }
            #endif
        }
        if firmwaresViewModel.isLoadMore {
            ProgressView("Loading more...")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.vertical)
        }
    }
}

struct FirmwareReleaseTypeMenu: View {
    @FocusState.Binding var focus: Bool
    let firmwareTypes: [FirmwareType] = FirmwareType.allCases
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    
    var body: some View {
        Menu {
            ForEach(Array(firmwareTypes.enumerated()), id: \.offset) { offset, firmwareType in
                Button(firmwareType.rawValue) {
                    firmwaresViewModel.isLoadMore = true
                    firmwaresViewModel.paginatedFirmwares = []
                    firmwaresViewModel.changeFirmwareReleaseType(releaseType: firmwareType)
                }
            }
        } label: {
            Label {
                Text(firmwaresViewModel.selectedFirmwareType.rawValue)
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .containerShape(RoundedRectangle(cornerRadius: 99))
        }
        #if os(tvOS)
        .frame(maxWidth: 180)
        #else
        .frame(maxWidth: 128)
        #endif
        .menuStyle(BorderlessButtonMenuStyle())
        .padding(8)
        #if os(tvOS)
        .background(focus ? Color.blue : Color.gray)
        #else
        .background(.thickMaterial)
        #endif
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

struct FirmwareTypeMenu: View {
    @FocusState.Binding var focus: Bool
    let firmwareTypes: [FirmwareTypes] = FirmwareTypes.allCases
    @EnvironmentObject var firmwaresViewModel: FirmwaresViewModel
    
    var body: some View {
        Menu {
            ForEach(Array(firmwareTypes.enumerated()), id: \.offset) { offset, firmwareType in
                Button(firmwareType.rawValue) {
                    firmwaresViewModel.isLoadMore = true
                    firmwaresViewModel.paginatedFirmwares = []
                    firmwaresViewModel.changeFilter(filter: firmwareType)
                }
            }
        } label: {
            Label {
                Text(firmwaresViewModel.filter.rawValue)
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .containerShape(RoundedRectangle(cornerRadius: 99))
        }
        #if os(tvOS)
        .frame(maxWidth: 180)
        #else
        .frame(maxWidth: 128)
        #endif
        .menuStyle(BorderlessButtonMenuStyle())
        .padding(8)
        #if os(tvOS)
        .background(focus ? Color.blue : Color.gray)
        #else
        .background(.thickMaterial)
        #endif
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
