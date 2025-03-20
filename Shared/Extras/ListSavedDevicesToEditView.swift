//
//  ListSavedDevicesToEditView.swift
//  PearDB
//
//  Created by Paras KCD on 20/3/25.
//

import SwiftUI

struct ListSavedDevicesToEdit: View {
    @FetchRequest(sortDescriptors: []) var storedData: FetchedResults<Entry>
    
    @EnvironmentObject var dbViewModel: DatabaseViewModel
    @Environment(\.presentations) private var presentations
    @Environment(\.dismiss) var dismiss
    @State var isAddDeviceDialogOpened = false
    @State var savedDevices: [Entry] = []
    let columns = [GridItem(.adaptive(minimum: 300))]
    let device: Device
    
    
    var body: some View {
        VStack {
            ScrollView {
                if !dbViewModel.devices.isEmpty {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                        if !savedDevices.isEmpty {
                            ForEach(savedDevices, id: \.id) { entry in
                                let map = dbViewModel.mapEntriesToDevices(entry: entry)
                                let firmware = map.1
                                if let device = map.0 {
                                    Button {
                                        dbViewModel.selectedEntry = entry
                                        isAddDeviceDialogOpened.toggle()
                                    } label: {
                                        DeviceItemLabelView(device: device, entry: entry, firmware: firmware)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            FooterView {
                GenericButtonView(label: "Cancel") {
                    dismiss()
                }
                GenericButtonView(label: "Add Device") {
                    dbViewModel.selectedEntry = nil
                    isAddDeviceDialogOpened.toggle()
                }
            }
        }
        .onAppear {
            self.savedDevices = storedData.filter({ data in
                data.key == device.key
            })
        }
        .sheet(isPresented: $isAddDeviceDialogOpened) {
            AddDeviceModalView(device: device)
                .environment(\.presentations, presentations + [$isAddDeviceDialogOpened])
                .onDisappear {
                    self.savedDevices = storedData.filter({ data in
                        data.key == device.key
                    })
                }
        }
    }
}
