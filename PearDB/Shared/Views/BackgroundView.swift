//
//  BackgroundView.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.black.opacity(0.5))
            .blur(radius: 0.01, opaque: false)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
