//
//  HomeScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct HomeScreen: View {
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
              Text("Buy Rune!, this is the main landing page")
          }
      }
  }

    var bottomBar: some View {
        Color.clear
            .frame(height: 5)
            .background(BlurView().ignoresSafeArea())
    }
}
