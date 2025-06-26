//
//  newDeviceView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct newDeviceView: View {
    
    @EnvironmentObject private var dbViewModel: DatabaseViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var fwViewSwitch: Bool = false
    @State private var fwSearchText = ""
    @State private var selectedDevice: Device?
    @State private var showOtherDevices: Bool = false
    @State private var showSelectedDeviceDetailView: Bool = false
    @State private var searchText = ""
    @ObservedObject private var downloader = AppleDBDownloader.shared
    
    private let normalDeviceTypes: Set<String> = [
        "iPhone", "iPod", "iPod mini", "iPod nano", "iPod shuffle", "iPod touch",
        "iPad", "iPad Air", "iPad Pro", "iPad mini",
        "iMac", "MacBook Pro", "MacBook Air", "MacBook", "Mac mini", "Mac Studio", "Mac Pro",
        "HomePod", "headset", "Apple Watch", "AppleTV"
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Add Device")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: {
                        dismiss()
                        dbViewModel.search(searchString: "")
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .imageScale(.large)
                    }
                }
                .padding()

                TextField("Search devices", text: $searchText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText, initial: true) { oldValue, newValue in
                        dbViewModel.search(searchString: newValue)
                    }
                    .searchable(text: $searchText, prompt: "Search devices")

                Toggle(isOn: $showOtherDevices) {
                    Text("Show other devices")
                }
                .padding(.horizontal)
                .onChange(of: showOtherDevices) {
                    dbViewModel.search(searchString: searchText)
                }
                
                ScrollView {
                    if !dbViewModel.searchedDevices.isEmpty {
                        LazyVStack(alignment: .leading) {
                            ForEach(dbViewModel.searchedDevices.lazy, id: \.key) { device in
                                Button {
                                    selectedDevice = device
                                    showSelectedDeviceDetailView.toggle()
                                } label: {
                                    HStack {
                                        let mappedImageKey: String = {
                                            for pair in deviceKeyMappings where pair.count > 1 && pair[1] == device.key {
                                                return pair[0]
                                            }
                                            return device.key
                                        }()
                                        if let deviceImages = dbViewModel.images.first(where: { $0.key == mappedImageKey }),
                                           let firstIndex = deviceImages.index.first {
                                            let urlString = "https://img.appledb.dev/device@64/\(mappedImageKey)/\(firstIndex.idText).png"
                                            AsyncImageView(url: urlString)
                                                .frame(width: 32, height: 64)
                                        } else {
                                            Image(.sad)
                                                .resizable()
                                                .frame(width: 32, height: 64)
                                        }
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
        .sheet(isPresented: $showSelectedDeviceDetailView) {
            if let selected = selectedDevice {
                DeviceDetailView(device: selected, fromDB: true)
                    .frame(width: 768)
            }
        }
        .navigationTitle("Add Device")
        .onAppear {
            dbViewModel.search(searchString: "")
        }
    }
}

#Preview {
    NavigationStack {
        newDeviceView()
            .environmentObject(DatabaseViewModel())
    }
}
