//
//  dbDetailView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct dbDetailView: View {
    
    let entry: Entry
    
    var body: some View {
        Spacer()
        Image(systemName: "ipad.landscape.and.iphone")
            .font(.system(size: 120))
        List {
            LabeledContent {
                Text(entry.name ?? "Unknown")
            } label: {
                Text("Product Name")
            }
            Section("Product Details") {
                LabeledContent {
                    Text(entry.identifier?.joined(separator: ", ") ?? "Unknown")
                } label: {
                    Text("Identifier")
                }
                LabeledContent {
                    Text(entry.board?.joined(separator: ", ") ?? "Unknown")
                } label: {
                    Text("Board")
                }
                LabeledContent {
                    Text(entry.model?.joined(separator: ", ") ?? "Unknown")
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
        }.navigationTitle(entry.name ?? "Device")
    }
}

//#Preview {
//    NavigationStack {
//        dbDetailView()
//    }
//}
