//
//  AddToHardwareView.swift
//  PearDB
//
//  Created by Kane Parkinson on 25/08/2024.
//

import SwiftUI

struct AddToHardwareView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var DBModel: appleDBPoll
    @EnvironmentObject var fwModel: firmwareModel
    @ObservedObject var vm: EditHardwareViewModel
    @State private var returnToAdditionalInfo: Bool = false
    var body: some View {
        VStack {
            if returnToAdditionalInfo {
                AdditionalInformationView(vm: vm)
                
            } else {
                Text("Is this correct?")
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
                AsyncCachedImage(
                    url: URL(string: "https://img.appledb.dev/device@main/\(DBModel.identifier)/0.avif"),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                )
    //            Text("\(DBModel.name)")
    //            Text("\(DBModel.released)")
    //            Text("\(DBModel.soc)")
    //            Text("\(DBModel.arch)")
    //            Text("\(DBModel.build)")
    //            Text("\(DBModel.version)")
                Text("\(DBModel.identifier)")
                Text("OS: \(fwModel.osStr)")
                Text("Version: \(fwModel.version)")
                Text("Build: \(fwModel.build)")
                Text("Internal \(fwModel.buildInternal)")
                Text("Beta \(fwModel.buildBeta)")
                Text("RC \(fwModel.buildRC)")
                Button(action: {
                    withAnimation(.easeInOut) {
                        returnToAdditionalInfo = true
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .frame(width: 100)
                            .foregroundStyle(Color.red)
                        Text("Cancel")
                            .foregroundStyle(Color.white)
                    }
                })
                Button(action: {
                    do {
                        vm.hardware.identifier = DBModel.identifier
                        vm.hardware.device = DBModel.name
                        vm.hardware.version = fwModel.version
                        vm.hardware.build = fwModel.build
                        vm.hardware.chip = DBModel.soc
                        vm.hardware.buildBeta = fwModel.buildBeta
                        
                        try vm.save()
                        dismiss()
                    } catch {
                        print(error)
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .frame(width: 100)
                            .foregroundStyle(Color.green)
                        Text("Proceed")
                            .foregroundStyle(Color.white)
                    }
                })
            }
        }
    }
}

//#Preview {
//    AddToHardwareView()
//}
