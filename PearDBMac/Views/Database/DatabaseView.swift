//
//  DatabaseView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
//

import SwiftUI

struct DatabaseView: View {
    @FetchRequest(sortDescriptors: []) var storedData: FetchedResults<Entry>
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
                            .padding(16)
                            .background(.thickMaterial)
                            .cornerRadius(99)
                            .overlay {
                                RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                    } searchable: { searchString in
                        
                    }
                    
                    ScrollView {
                        if !dbViewModel.devices.isEmpty {
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                                if (!storedData.isEmpty) {
                                    ForEach(storedData, id: \.key) { entry in
                                        let map = dbViewModel.mapEntriesToDevices(entry: entry)
                                        let firmware = map.1
                                        if let device = map.0 {
                                            DeviceItemView(device: device, entry: entry, firmware: firmware)
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
        .sheet(isPresented: $isShowingNewDevice) {
            NewDeviceView()
                .environmentObject(dbViewModel)
                .frame(width: 768)
        }
    }
}
