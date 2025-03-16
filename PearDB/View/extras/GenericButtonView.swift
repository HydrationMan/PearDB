//
//  GenericButtonView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct GenericButtonView: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(label)
                .frame(minWidth: 72)
                .font(.headline)
                .containerShape(RoundedRectangle(cornerRadius: 99))
                .padding(16)
                .background(.thinMaterial)
                .cornerRadius(99)
                .overlay {
                    RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
                }
        })
        .buttonStyle(.plain)
    }
}
