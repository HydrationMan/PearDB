//
//  AppleDBDevices.swift
//  PearDBProject
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

struct Device: Codable {
    var name: String
    var identifier: [String]
    var key: String
    var soc: String
    var type: String
    var board: [String]
    var model: [String]
    var released: [String]?
}
