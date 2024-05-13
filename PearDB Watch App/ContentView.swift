//
//  ContentView.swift
//  PearDB Watch App
//
//  Created by Kane Parkinson on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                TabView() {
                    SoundView()
                }
            }
            .tabViewStyle(.carousel)
        }
        .compositingGroup()
    }
}
