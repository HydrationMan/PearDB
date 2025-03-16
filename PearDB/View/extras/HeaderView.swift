//
//  HeaderView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct HeaderView<Content: View>: View {
    @State var search: String = ""
    var title: String
    @ViewBuilder let content: Content
    var searchable: ((String) -> Void)? = nil
    
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
            
            if (searchable != nil) {
                Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { searching in
                    searchable!(searching)
                } onCancel: {
                    
                }
            }
            
            content
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .compositingGroup()
        .shadow(radius: 5)
        .border(width: 1, edges: [.bottom], color: Color(.gray))
    }
}
