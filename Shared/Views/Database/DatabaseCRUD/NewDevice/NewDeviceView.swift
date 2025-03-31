//
//  NewDeviceView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
//

import SwiftUI

struct NewDeviceView: View {
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    @Environment(\.presentations) private var presentations
    @Environment(\.dismiss) private var dismiss
    @State var search: String = ""
    @State var selectedDevice: Device? = nil
    @State var showSelectedDeviceDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HeaderView(title: "Add Device") {
                    VStack(alignment: .trailing) {
                        XMarkButtonView {
                            dismiss()
                            dbViewModel.search(searchString: "")
                        }
                    }
                    .visionOSMods.padding3D("depth")
                } searchable: { searchString in
                    dbViewModel.search(searchString: searchString)
                }
                
                #if os(iOS)
                    Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { searchString in
                        dbViewModel.search(searchString: searchString)
                    } onCancel: {
                        search = ""
                        dbViewModel.search(searchString: "")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                    NewDeviceScrollView()
                        .environmentObject(dbViewModel)
                        .navigationTitle("Add Device")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                XMarkButtonView {
                                    dismiss()
                                    dbViewModel.search(searchString: "")
                                }
                            }
                        }
                #else
                    NewDeviceScrollView()
                    .environmentObject(dbViewModel)
                #endif
            }
        }
    }
}

struct NewDeviceScrollView: View {
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    
    var body: some View {
        ScrollView {
            if !dbViewModel.searchedDevices.isEmpty {
                LazyVStack(alignment: .leading) {
                    ForEach(dbViewModel.searchedDevices.lazy, id:\.key) { device in
                        DeviceItemView(device: device, fromSheet: true)
                            .padding(.horizontal)
                    }
                    Color.clear.padding()
                }
            }
        }
    }
}
