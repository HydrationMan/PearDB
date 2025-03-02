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
            ScrollView {
                if !dbViewModel.searchedDevices.isEmpty {
                    LazyVStack(alignment: .leading) {
                        ForEach(dbViewModel.searchedDevices.lazy, id:\.key) { device in
                            Button {
                                selectedDevice = device
                                showSelectedDeviceDetailView.toggle()
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
        .sheet(isPresented: $showSelectedDeviceDetailView) {
            if selectedDevice != nil {
                DeviceDetailView(device: selectedDevice!, fromDB: true)
                .frame(width: 768)
            }
        }
    }
}
