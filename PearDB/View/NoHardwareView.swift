//
//  NoHardwareView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/08/2024.
//

import SwiftUI

struct NoHardwareView: View {
    var body: some View {
        VStack {
            Text("No Devices Available.")
                .font(.largeTitle.bold())
            Text("Add some devices to get started!")
                .font(.callout)
        }
    }
}

#Preview {
    NoHardwareView()
}
