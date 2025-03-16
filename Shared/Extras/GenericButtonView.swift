//
//  GenericButtonView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
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
                .padding(8)
                .background(.thinMaterial)
                .cornerRadius(99)
                .overlay {
                    #if os(macOS)
                    RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    #else
                    RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
                    #endif
                }
        })
        .buttonStyle(.plain)
    }
}
