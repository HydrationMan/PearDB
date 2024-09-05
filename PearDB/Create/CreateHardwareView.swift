//
//  CreateHardwareView.swift
//  PearDB
//
//  Created by Kane Parkinson on 07/08/2024.
//

import SwiftUI
import Combine
import Foundation

struct CreateHardwareView: View {
    @StateObject private var DBModel = appleDBPoll()
    @ObservedObject var vm: EditHardwareViewModel
    @State private var showRetrieveView: Bool = false
    @State private var showErrorView: Bool = false
    @State private var showEditView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if !vm.hardware.objectID.isTemporaryID == true {
                    EditHardwareView(vm: vm, hardware: vm.hardware)
                } else {
                    if showRetrieveView == true {
                        RetrieveFromAppleDBView(vm: vm)
                            .environmentObject(DBModel)
                    } else {
                        if showErrorView == true {
                            RetrieveErrorView(vm: vm)
                        } else {
                            Text("Please enter a Device Identifier.")
                                .font(.system(size: 26, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], 20)
                            Text("This will be used to gather information about your target device from AppleDB.")
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], 20)
                            TextField("Device Identifier. E.G: iPhone16,2", text: $DBModel.identifier)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled()
                                .padding([.leading, .trailing], 50)
                            Button(action: {
                                DBModel.simplefetch()
                                if DBModel.error == true {
                                    withAnimation(.easeInOut) {
                                        showErrorView = true
                                    }
                                } else {
                                    withAnimation(.easeInOut) {
                                        showRetrieveView = true
                                    }
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .frame(width: 100)
                                    Text("Search")
                                        .foregroundColor(Color.white)
                                }
                                
                            })
                            .padding([.all], 20)
                        }
                    }
                }
            }
        }.navigationTitle("New Device")
    }
}
