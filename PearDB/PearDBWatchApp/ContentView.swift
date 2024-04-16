//
//  ContentView.swift
//  PDB Watch App
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI


extension Color {
    static let PearCyan = Color("PearCyan")
}

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                TabView() {
                    HomeScreen()
                    DeviceScreen()
                    SettingsScreen()
                    SoundScreen()
                }
            }
            .tabViewStyle(.carousel)
        }
        .compositingGroup()
    }
}

let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
}()
