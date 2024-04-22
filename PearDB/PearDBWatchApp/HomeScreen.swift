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
            VStack {
                let appledb = URL(string: "https://img.appledb.dev/device@main/\(modelName)/0.png")
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(name)").padding(.bottom).foregroundColor(.primary)
                        Text("Device:")
                            .font(.system(size: 12, weight: .heavy, design: .default))
                            .lineLimit(3)
                        Text("\(modelName)").foregroundColor(.primary)
                            .font(.system(size: 12))
                        Text("Running:")
                            .font(.system(size: 12, weight: .heavy, design: .default))
                            .lineLimit(3)
                        Text("\(osName) \(version) (\(buildNumber()))").foregroundColor(.primary)
                            .font(.system(size: 12))
                            .lineLimit(3)
                    }.padding()
                    URLImage(appledb!)
                        .frame(width:60, height: 140)
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
