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
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
  var body: some View {
      ZStack {
          Color.bgColor.ignoresSafeArea()
          ScrollView {
              VStack {
                  Link("Buy 16Player!, this is the Settings page", destination: URL(string:"https://chariz.com/buy/16player")!)
              }
          }.bottomSafeAreaInset(bottomBar)
      }
  }

    var bottomBar: some View {
        Color.clear
            .frame(height: 5)
            .background(BlurView(style: .prominent).ignoresSafeArea())
    }
}
