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
                Text("deviceID: \(deviceID)")
                let appledb = URL(string: "https://img.appledb.dev/device@main/\(deviceID)/0.avif")
                Text("\(deviceID) running \(osName) \(version)")
                URLImage(appledb!)
                    .frame(width: 100, height: 200)
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
