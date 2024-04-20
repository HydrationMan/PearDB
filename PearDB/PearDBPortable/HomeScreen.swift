//
//  HomeScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI
import Combine
import UIKit

struct HomeScreen: View {
    @State var devices: Dictionary<String, [DeviceGroup]>?
    @State var homePage: HomePage?
    @State var currentDeviceDisplayName: String?
    
    @State var isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad) // false if iPhone/iPod, true if iPad

    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    @State var name = UIDevice.current.name
    let version = UIDevice.current.systemVersion
    let deviceID = UIDevice.modelName
    let osName = UIDevice.current.systemName
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .PearCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    CurrentDeviceView(name: name, deviceID: deviceID, osName: osName, version: version, isiPad: isiPad)
                    
                    if let homePage = homePage {
                        GridItemView(title: "Products", items: homePage.deviceTypeCardArray)
                        GridItemView(title: "Firmware versions", items: homePage.osTypeCardArray)
                    }
                }.padding()
            }.bottomSafeAreaInset(bottomBar)
                
        }.onAppear {
            Shared.sharedInstance.deviceManager.getHomePage { homePage in
                print(homePage.deviceTypeCardArray[0].image.type)
                self.homePage = homePage
            }
            
            Shared.sharedInstance.deviceManager.getDevices { devices in
                self.devices = devices
            }
        }
    }

    var bottomBar: some View {
        Color.clear
            .frame(height: 5)
            .background(BlurView(style: .prominent).ignoresSafeArea())
    }
}
