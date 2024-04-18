//
//  Product.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String = UUID().uuidString
    
    var title: String
    var image: AppleDBImage
    var link: String
}
