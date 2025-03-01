//
//  FooterView.swift
//  PearDBMac
//
//  Created by Paras KCD on 1/3/25.
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
        .border(width: 1, edges: [.top], color: Color(NSColor.gridColor))
    }
}
