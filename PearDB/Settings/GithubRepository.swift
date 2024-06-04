//
//  GithubRepository.swift
//  PearDB
//
//  Created by Kane Parkinson on 13/05/2024.
//

import SwiftUI

struct GithubRepository: View {
    var body: some View {
        SettingsView()
            .onAppear {
                UIApplication.shared.open(URL(string: "https://github.com/hydrationMan/PearDB")!)
            }
    }
}

#Preview {
    GithubRepository()
}
