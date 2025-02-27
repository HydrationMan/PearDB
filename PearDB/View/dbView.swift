//
//  dbView.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

struct dbView: View {
    
    @State private var isShowingNewDevice = false
    
    @FetchRequest(fetchRequest: Entry.all()) private var entry
    
    var provider = DeviceEntryProvider.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(entry) { entry in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: dbDetailView(entry: entry)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        dbRowView(entry: entry)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingNewDevice.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isShowingNewDevice) {
                NavigationStack {
                    newDeviceView(vm: .init(provider: .shared))
                }
            }
            .navigationTitle("Database")
        }
    }
}

#Preview {
    NavigationStack {
        dbView()
    }
}
