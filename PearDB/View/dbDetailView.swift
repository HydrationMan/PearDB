//
//  dbDetailView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct dbDetailView: View {
    
    let entry: Entry
    let device: Device
    
    var body: some View {
        Spacer()
        Image(systemName: "ipad.landscape.and.iphone")
            .font(.system(size: 120))
        List {
            LabeledContent {
                Text(device.name ?? "Unknown")
            } label: {
                Text("Product Name")
            }
            Section("Product Details") {
                LabeledContent {
                    Text(device.identifier?.map(String.init).joined(separator: ", ") ?? "Unknown")
                } label: {
                    Text("Identifier")
                }
                LabeledContent {
                    Text(device.board?.map(String.init).joined(separator: ", ") ?? "Unknown")
                } label: {
                    Text("Board")
                }
                LabeledContent {
                    Text(device.model?.map(String.init).joined(separator: ", ") ?? "Unknown")
                } label: {
                    Text("Model")
                }
                LabeledContent {
                    Text(entry.released ?? "Unknown")
                } label: {
                    Text("Released")
                }
            }
            LabeledContent {
                Text(entry.serial ?? "Unknown")
            } label: {
                Text("Serial Number")
            }
        }.navigationTitle(device.name ?? "Device")
    }
}

//#Preview {
//    NavigationStack {
//        dbDetailView()
//    }
//}
