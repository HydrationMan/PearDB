//
//  HomePage.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import Foundation

struct HomePage : Codable {
    var deviceTypeCardArray: [Product]
    var osTypeCardArray: [Product]
}

struct AppleDBImage: Codable {
    var type: String
    var key: String
}
