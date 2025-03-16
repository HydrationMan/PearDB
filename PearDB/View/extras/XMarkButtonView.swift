//
//  XMarkButtonView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct XMarkButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
                .containerShape(RoundedRectangle(cornerRadius: 99))
                .padding(16)
                .background(.thickMaterial)
                .cornerRadius(99)
                .overlay {
                    RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
                }
        })
        .buttonStyle(.plain)
    }
}
