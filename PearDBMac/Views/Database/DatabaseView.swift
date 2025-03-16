//
//  DatabaseView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
//

import SwiftUI

struct DatabaseView: View {
    let columns = [GridItem(.adaptive(minimum: 300))]
    @State var search: String = ""
    @State private var isShowingNewDevice = false
    
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    
    var body: some View {
        ZStack {
            Rectangle.semiOpaqueWindow().padding(-1)
            
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
                            .padding(8)
                            .background(.thickMaterial)
                            .cornerRadius(99)
                            .overlay {
                                RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
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
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewDevice) {
            NewDeviceView()
                .environmentObject(dbViewModel)
                .frame(width: 768)
        }
    }
}
