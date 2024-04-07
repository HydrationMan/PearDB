//
//  HomeScreen.swift
//  PearDBWatchApp
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .myCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Buy Rune!, this is the main landing page")
            }
        }
    }
}
