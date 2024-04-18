//
//  CurrentDeviceView.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import SwiftUI

struct CurrentDeviceView: View {
    var name: String
    var deviceID: String
    var osName: String
    var version: String
    var isiPad: Bool
    
    var body: some View {
        VStack {
            let appledb = URL(string: "https://img.appledb.dev/device@main/\(deviceID)/0.webp")
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(name)").font(.title).padding(.bottom).foregroundColor(.primary)
                    Text("\(deviceID)").foregroundColor(.primary)
                    Text("\(osName) \(version) (\(buildNumber()))").foregroundColor(.primary)
                }.padding()
                Spacer()
                URLImage(appledb!)
                    .frame(width: (isiPad ? 275 : 50), height: (isiPad ? 355 : 100))
                    .padding()
            }
            .background(BackgroundView())
            .padding()

// Dynamic Loading
//                if let devices = devices {
//                    ForEach(devices.iPhones) { iPhone in
//
//                        Text("iPhone : \(iPhone.name)")
//
//                    }
//
//
//                }
            

        }
    }
}

struct CurrentDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDeviceView(name: "Testing", deviceID: "Testing", osName: "Testing", version: "Testing", isiPad: false)
    }
}
