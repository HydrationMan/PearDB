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
    @State var devices: Devices?
    
    @State var iPhoneiPad: Bool = false // false if iPhone, true if iPad

    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

    }
    let version = UIDevice.current.systemVersion
    let deviceID = UIDevice.modelName
    let osName = UIDevice.current.systemName
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .PearCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .bottomSafeAreaInset(bottomBar)
            VStack {
                
                let appledb = URL(string: "https://img.appledb.dev/device@main/\(deviceID)/0.webp")
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(UIDevice.current.name)").font(.title).padding(.bottom).foregroundColor(.primary)
                        Text("Device : \(deviceID)").foregroundColor(.primary)
                        Text("Running : \(osName) \(version)").foregroundColor(.primary)
                    }.padding()
                    Spacer()
                    URLImage(appledb!)
                        .frame(width: 50, height: 100)
                        .padding()
                    
                }.background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.5))
                    .blur(radius: 3, opaque: false)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5))
                .padding()
                
                Spacer()

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
        }.onAppear {
            Shared.sharedInstance.deviceManager.getGroups { devices in
                self.devices = devices

            }
        }
    }

    var bottomBar: some View {
        Color.clear
            .frame(height: 5)
            .background(BlurView().ignoresSafeArea())
    }
}

class RemoteImageLoader: ObservableObject {
    @Published var data: Data = Data()
    init(imageURL: URL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async { self.data = data }
            }
        .resume()
        
    }
}
struct URLImage: View {
    @ObservedObject var remoteImageLoader: RemoteImageLoader
    init(_ imageUrl: URL) {
        remoteImageLoader = RemoteImageLoader(imageURL: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: UIImage(data: remoteImageLoader.data) ?? UIImage())
            .resizable()
            .renderingMode(.original)
    }
}
