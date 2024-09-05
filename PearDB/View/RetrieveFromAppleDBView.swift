//
//  RetrieveFromAppleDBView.swift
//  PearDB
//
//  Created by Kane Parkinson on 18/08/2024.
//

import SwiftUI

struct RetrieveFromAppleDBView: View {
    @ObservedObject var vm: EditHardwareViewModel
    @State private var showConfirmView: Bool = false
    var body: some View {
        VStack {
            if showConfirmView {
                ConfirmFromAppleDBView(vm: vm)
            } else {
                ProgressView()
                Text("Talking to AppleDB...")
                    .font(.largeTitle.bold())
                Text("Please wait.")
                    .font(.callout)
            }
        }.onAppear(perform: transitionView)
    }
    private func transitionView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut) {
                showConfirmView = true
            }
        }
    }
}
