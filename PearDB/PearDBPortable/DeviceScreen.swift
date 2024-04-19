//
//  DeviceScreen.swift
//  PearDBPortable
//
//  Created by Kane Parkinson on 19/01/24.
//

import SwiftUI

struct DeviceScreen: View {
    @State var devices: Dictionary<String, [DeviceGroup]>?
    @State var homePage: HomePage?
    
    @State var selectedProduct: String
    @State var possibleProducts: [String] = ["All"]
    
    @State var selectedDevice: String
    @State var possibleDevices: [String] = ["All"]
    
    func fixBar() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        let apparence = UITabBarAppearance()
        apparence.configureWithTransparentBackground()
        if #available(iOS 15.0, *) {UITabBar.appearance().scrollEdgeAppearance = apparence}
    }
    
    init() {
        self.selectedProduct = "All"
        self.selectedDevice = "All"
        fixBar()
    }
    
    init(selectedProduct: String) {
        self.selectedProduct = selectedProduct
        self.selectedDevice = "All"
        fixBar()
    }
    
  var body: some View {
      ZStack {
          LinearGradient(colors: [.purple, .PearCyan],startPoint: .topLeading,endPoint: .bottomTrailing)
              .ignoresSafeArea()
          .bottomSafeAreaInset(bottomBar)
          VStack {
              if let homePage = homePage, let devices = devices {
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                          ForEach(possibleProducts, id: \.self) { product in
                              Button(product, action: {
                                  self.selectedProduct = product
                              })
                          }
                      }
                  }
                  
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                          ForEach(Array(devices.keys + ["All"]).filter( { $0.contains(selectedProduct) || selectedProduct == "All" || $0 == "All"}), id: \.self) { key in
                              Button(key, action: {
                                  self.selectedDevice = key
                              })
                          }
                      }

                  }
                  
                  
                  List {
                      ForEach(Array(devices.keys).filter( { $0.contains(selectedProduct) || selectedProduct == "All" }), id: \.self) { key in
                          if let groups = devices[key] {
                              ForEach(groups.filter( { $0.name.contains(selectedDevice) || selectedDevice == "All" })) { group in
                                  Text(group.name)
                              }
                          }
                          
                      }.listRowBackground(Color.clear)
                  }.background(Color.clear)
                  //
//                  if let lastProduct = devices[key]?.last?.products?.last,
//                  let firstImage = lastProduct.images?.index.first {
//                   let imageURL = URL(string: "https://img.appledb.dev/device@preview/\(lastProduct.key)/\(firstImage.id).webp")!
//
//                   ProductView(imageURL: imageURL, text: key)
//                 }
              }
          
//          VStack {
//              Link("Buy 16Player!, this is the Settings page", destination: URL(string:"https://chariz.com/buy/16player")!)
//          }

          }
      }.onAppear {
          if !(possibleProducts.count > 1) {
              Shared.sharedInstance.deviceManager.getHomePage { homePage in
                  self.homePage = homePage
                  
                  homePage.deviceTypeCardArray.forEach {
                      self.possibleProducts.append($0.title)
                  }
              }
          }
          Shared.sharedInstance.deviceManager.getDevices { devices in
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
