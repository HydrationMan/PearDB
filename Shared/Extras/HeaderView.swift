//
//  HeaderView.swift
//  PearDBMac
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

struct HeaderView<Content: View>: View {
    @State var search: String = ""
    var title: String
    @ViewBuilder let content: Content
    var searchable: ((String) -> Void)? = nil
    
    
    var body: some View {
        #if os(iOS)
        #else
            HStack(alignment: .center) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .visionOSMods.padding3D("depth")
                
                if (searchable != nil) {
                    Searchbar(searchText: $search, hasCancel: !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) { searching in
                        searchable!(searching)
                    } onCancel: {
                        
                    }
                    .visionOSMods.padding3D("depth")
                }
                
                content
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(.ultraThickMaterial)
            .compositingGroup()
            .shadow(radius: 5)
        #endif
    }
}
