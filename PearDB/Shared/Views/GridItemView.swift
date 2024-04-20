//
//  GridItemView.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import SwiftUI

struct GridItemView: View {
    var title: String
    var items: [Product]
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
            ForEach(items) { product in
                
                ProductView(imageURL: URL(string: "https://img.appledb.dev/\(product.image.type)@128/\(product.image.key)/0.png".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, text: product.title)
                
            }
            
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        GridItemView(title: "Testing", items: [])
    }
}
