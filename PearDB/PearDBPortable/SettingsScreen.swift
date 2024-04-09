//
//  SettingsScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct SettingsScreen: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
  var body: some View {
      ZStack {
          LinearGradient(colors: [.purple, .PearCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
              .ignoresSafeArea()
          .bottomSafeAreaInset(bottomBar)
          VStack {
              Link("Buy 16Player!, this is the Settings page", destination: URL(string:"https://chariz.com/buy/16player")!)
          }
      }
  }

    var bottomBar: some View {
        Color.clear
            .frame(height: 5)
            .background(BlurView().ignoresSafeArea())
    }
}
