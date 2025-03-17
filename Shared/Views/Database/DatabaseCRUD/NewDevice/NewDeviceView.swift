//
//  NewDeviceView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
//

import SwiftUI

struct NewDeviceView: View {
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    @Environment(\.dismiss) private var dismiss
    @State var search: String = ""
    @State var selectedDevice: Device? = nil
    @State var showSelectedDeviceDetailView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(title: "Add Device") {
                VStack(alignment: .trailing) {
                    XMarkButtonView {
                        dismiss()
                        dbViewModel.search(searchString: "")
                    }
                }
            } searchable: { searchString in
                dbViewModel.search(searchString: searchString)
            }
            
            #if os(macOS)
                NewDeviceScrollView() { device in
                    selectedDevice = device
                    showSelectedDeviceDetailView.toggle()
                }
                .environmentObject(dbViewModel)
            #else
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Add Device")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        XMarkButtonView {
                            dismiss()
                            search = ""
                            dbViewModel.search(searchString: "")
                        }
                    }
                    
                    Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { searchString in
                        dbViewModel.search(searchString: searchString)
                    } onCancel: {
                        search = ""
                        dbViewModel.search(searchString: "")
                    }
                }
                .padding([.top, .horizontal])
            
                NewDeviceScrollView() { device in
                    selectedDevice = device
                    showSelectedDeviceDetailView.toggle()
                }
                .environmentObject(dbViewModel)
            #endif
        }
        .sheet(isPresented: $showSelectedDeviceDetailView) {
            if selectedDevice != nil {
                #if os(macOS)
                    DeviceDetailView(device: selectedDevice!, fromDB: true)
                    .frame(width: 768)
                #else
                    DeviceDetailView(device: selectedDevice!, fromDB: true)
                #endif
            }
        }
    }
}

struct NewDeviceScrollView: View {
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    var action: (_ device: Device) -> Void
    
    var body: some View {
        ScrollView {
            if !dbViewModel.searchedDevices.isEmpty {
                LazyVStack(alignment: .leading) {
                    ForEach(dbViewModel.searchedDevices.lazy, id:\.key) { device in
                        Button {
                            action(device)
                        } label: {
                            HStack {
                                AsyncImageView(url: "https://img.appledb.dev/device@64/\(device.key)/0.png")
                                    .frame(width: 32, height: 64)
                                Text(device.name)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                    Color.clear.padding()
                }
            }
        }
    }
}
