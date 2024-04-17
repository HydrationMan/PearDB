//
//  HomeScreen.swift
//  PearDBWatchApp
//
//  Created by Kane Parkinson on 02/04/2024.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        let name = WKInterfaceDevice.current().name
        let version = WKInterfaceDevice.current().systemVersion
        let osName = WKInterfaceDevice.current().systemName
        ZStack {
            LinearGradient(colors: [.purple, .PearCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                let appledb = URL(string: "https://img.appledb.dev/device@main/\(modelName)/0.png")
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(name)").font(.title3).padding(.bottom).foregroundColor(.primary)
                        Text("Device: \(modelName)").foregroundColor(.primary)
                        Text("Running: \(osName) \(version)").foregroundColor(.primary)
                    }.padding()
                    Spacer()
                    URLImage(appledb!)
                        .frame(width:80, height: 150)
                        .padding()
                }
            }.background(RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.5))
                .blur(radius: 1, opaque: false)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5))
            .padding()
            
            Spacer()
        }
    }
}
