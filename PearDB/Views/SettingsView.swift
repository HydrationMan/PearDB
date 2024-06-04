//
//  SettingsView.swift
//  PearDB
//
//  Created by Kane Parkinson on 12/05/2024.
//

import SwiftUI

struct SettingsView: View {
    let navigationTable = [
        [
        NavigationItem(name: "Display", description: "", menu: .displays),
        NavigationItem(name: "Languages", description: "", menu: .languages),
        ],
        [
        NavigationItem(name: "Licences", description: "", menu: .licences),
        NavigationItem(name: "Github Repository", description: "", menu: .githubrepository),
        NavigationItem(name: "Support PearDB", description: "", menu: .supportviakofi),
        ],
        [
        NavigationItem(name: "Clear Network Cache", description: "", menu: .clearnetworkcache),
        NavigationItem(name: "Reset Settings", description: "", menu: .resetsettings)
        ],
        [
        NavigationItem(name: "Detail", description: "", menu: .detail)
        ],
        ]
        
    let sectionTitles = ["General", "About", "Advanced", "Detail"]
    @State private var SettingsSubView: String? = nil
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                        Section(header: Text(sectionTitles[sectionIndex]).foregroundLinearGradient(colors: [Color(hex: 0x79a4f2), Color(hex: 0xc9dcff)], startPoint: .leading, endPoint: .trailing)) {
                            ForEach(navigationTable[sectionIndex], id: \.self) { rowData in
                                NavigationLink(rowData.name, value: rowData)
                            }
                        }
                    }
                }
                
                .navigationTitle("Settings")
                

                .navigationDestination(for: NavigationItem.self, destination: { item in
                    switch item.menu {
                    case .detail:
                        Detail()
                    case .displays:
                        Display()
                    case .languages:
                        Languages()
                    case .licences:
                        Licences()
                    case .githubrepository:
                        GithubRepository()
                    case .supportviakofi:
                        SupportPearDB()
                    case .clearnetworkcache:
                        ClearNetworkCache()
                    case .resetsettings:
                        ResetSettings()
                    }
                })
            }
        }
    }
}


struct NavigationItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var menu: Menu
}


enum Menu: String {
    case detail
    case displays
    case languages
    case licences
    case githubrepository
    case supportviakofi
    case clearnetworkcache
    case resetsettings
}


