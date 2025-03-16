//
//  FooterView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct FooterView<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .center) {
                content
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .compositingGroup()
        .border(width: 1, edges: [.top], color: Color(.gray))
    }
}
