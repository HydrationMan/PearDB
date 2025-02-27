//
//  DeviceRowView.swift
//  PearDB
//
//  Created by Kane Parkinson on 11/02/2025.
//

import SwiftUI

struct dbRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.name ?? "Unknown")
                .font(.system(size: 26,
                              design: .rounded).bold())
            Text(entry.identifier?.joined(separator: ", ") ?? "Unknown")
                .font(.callout.bold())
            Text(entry.model?.joined(separator: ", ") ?? "Unnown")
                .font(.callout.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                toggleMain()
            } label: {
                Image(systemName: "star")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundStyle(entry.isMain ? .yellow : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

private extension dbRowView {
    func toggleMain() {
        entry.isMain.toggle()
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error)
        }
    }
}

//#Preview {
//    dbRowView()
//}
