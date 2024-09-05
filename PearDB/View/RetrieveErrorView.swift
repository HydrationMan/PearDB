//
//  RetrieveErrorView.swift
//  PearDB
//
//  Created by Kane Parkinson on 26/08/2024.
//

import SwiftUI

struct RetrieveErrorView: View {
    @ObservedObject var DBModel = appleDBPoll()
    @ObservedObject var vm: EditHardwareViewModel
    @State private var showCreateView: Bool = false
    
    var body: some View {
        if showCreateView == true {
            CreateHardwareView(vm: vm)
        } else {
            VStack {
                Text("Something went wrong :(")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Text("Please check your Device Identifier and Try Again!")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                Text("If this error persists there may be an issue with AppleDB, or the device is not present on AppleDB.")
                    .font(.system(size: 12))
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding([.all], 20)
                Button(action: {
                    withAnimation(.easeInOut) {
                        showCreateView = true
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .frame(width: 100)
                            .foregroundColor(.red)
                        Text("Go back")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
