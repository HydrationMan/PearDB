//
//  ContentView.swift
//  PearDBWatch
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dbViewModel: DatabaseViewModel = .init()
    
    var body: some View {
        VStack {
            if dbViewModel.isLoading {
                Text("Loading")
            } else {
                let typeCounts = countDeviceTypes()
                
                if !typeCounts.isEmpty {
                    ForEach(typeCounts.keys.sorted(), id: \.self) { type in
                        Text("\(type): \(typeCounts[type] ?? 0)")
                    }
                } else {
                    Text("No devices found")
                }
            }
        }
        .padding()
    }
    
    private func countDeviceTypes() -> [String: Int] {
        var typeCounts: [String: Int] = [:]
        
        for entry in dbViewModel.storedEntries {
            let map = dbViewModel.mapEntriesToDevices(entry: entry)
            if let deviceType = map.0?.type {
                typeCounts[deviceType, default: 0] += 1
            }
        }
        
        return typeCounts
    }
}

#Preview {
    ContentView()
}
