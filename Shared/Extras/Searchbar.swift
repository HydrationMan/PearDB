//
//  Searchbar.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct Searchbar: View {
    @Binding var searchText: String
    var hasCancel: Bool = true
    var action: (String) -> Void
    var onCancel: ()->()
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
                .onChange(of: searchText) { prev, current in
                    if (prev != current) {
                        action(current)
                    }
                }
                .textFieldStyle(.plain)
            if hasCancel {
                Button(action: {
                    searchText = ""
                    onCancel()
                }) {
                    Image(systemName: "x.circle")
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 8)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut(duration: 1.0), value: UUID())
            }
        }
        .padding(8)
        .background(.thickMaterial)
        .cornerRadius(99)
        .overlay {
            #if os(macOS)
            RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
            #else
            RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
            #endif
        }
    }
}
