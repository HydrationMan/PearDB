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
//                Text(device.name ?? "Unknown")
                Text("Bruh")
            } label: {
                Text("Product Name")
            }
            Section("Product Details") {
                LabeledContent {
//                    Text(device.identifier?.map(String.init).joined(separator: ", ") ?? "Unknown")
                    Text("Bruh")
                } label: {
                    Text("Identifier")
                }
                LabeledContent {
//                    Text(device.board?.map(String.init).joined(separator: ", ") ?? "Unknown")
                    Text("Bruh")
                } label: {
                    Text("Board")
                }
                LabeledContent {
//                    Text(device.model?.map(String.init).joined(separator: ", ") ?? "Unknown")
                    Text("Bruh")
                } label: {
                    Text("Model")
                }
                LabeledContent {
//                    Text(entry.released ?? "Unknown")
                    Text("Bruh")
                } label: {
                    Text("Released")
                }
            }
            LabeledContent {
//                Text(entry.serial ?? "Unknown")
                Text("Bruh")
            } label: {
                Text("Serial Number")
            }
        }/*.navigationTitle(device.name ?? "Device")*/
        .navigationTitle("Bruh")
    }
}

//#Preview {
//    NavigationStack {
//        dbDetailView()
//    }
//}
