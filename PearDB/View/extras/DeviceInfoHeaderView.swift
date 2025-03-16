//
//  DeviceInfoHeaderView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct DeviceInfoHeaderView: View {
    var systemImage: String
    var label: String
    @Binding var expanded: Bool
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: systemImage)
                Text(label)
                    .font(.title3)
                Spacer()
                Image(systemName: expanded ? "chevron.up" : "chevron.down")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
