//
//  ProductView.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import SwiftUI

struct ProductView: View {
    var imageURL: URL
    var text: String
    var body: some View {
        VStack {
            URLImage(imageURL).padding().aspectRatio(contentMode: .fit)
            Text(text).padding()
        }.frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .aspectRatio(1.0, contentMode: .fill)
            .background(BackgroundView())
            .onTapGesture {
                
            }
        
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(imageURL: URL(string: "https://img.appledb.dev/images@128/mac_combo/0.png")!, text: "Mac")
    }
}
