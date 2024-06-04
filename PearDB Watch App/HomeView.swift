//
//  HomeView.swift
//  PearDB Watch App
//
//  Created by Kane Parkinson on 16/05/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("This app contains Complications to add to your Watch face(s).")
                .font(.system(size: 10))
                .padding()
            Text("Dedicated to Hugo Mason. 2005-2024.")
                .font(.system(size: 10))
            Text("Miss ya buddy.")
                .font(.system(size: 10))
            Image("Superbro")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
        }
    }
}

#Preview {
    HomeView()
}
