//
//  dbView.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

struct dbView: View {
    let columns = [GridItem(.adaptive(minimum: 300))]
    @State var search: String = ""
    @State private var isShowingNewDevice = false
    
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    
    var body: some View {
        ZStack {
//            Rectangle.semiOpaqueWindow().padding(-1)
            
            NavigationStack {
                VStack {
                    HeaderView(title: "My Devices") {
                        Button {
                            isShowingNewDevice.toggle()
                        } label: {
                            Label {
                                Text("Add Device")
                            } icon: {
                                Image(systemName: "macbook.and.iphone")
                            }
                            .containerShape(RoundedRectangle(cornerRadius: 99))
                            .frame(maxWidth: 128)
                            .padding(16)
                            .background(.thickMaterial)
                            .cornerRadius(99)
                            .overlay {
                                RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                    } searchable: { searchString in
                        }
                    if dbViewModel.isLoading {
                        ProgressView("Downloading your stored devices…")
                            .progressViewStyle(.circular)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            if !dbViewModel.devices.isEmpty {
                                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                                    if (!dbViewModel.storedEntries.isEmpty) {
                                        ForEach(dbViewModel.storedEntries) { entry in
                                            let map = dbViewModel.mapEntriesToDevices(entry: entry)
                                            let firmware = map.1
                                            if let device = map.0 {
                                                DeviceItemView(device: device, entry: entry, firmware: firmware)
                                                    .id(entry.id)
                                                    .environmentObject(dbViewModel)
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
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewDevice) {
            newDeviceView()
                .environmentObject(dbViewModel)
                .frame(width: 768)
        }
        .onDisappear {
            print("dbView disappeared")
        }
        .onAppear {
            print("dbView appeared")
        }
    }
}
