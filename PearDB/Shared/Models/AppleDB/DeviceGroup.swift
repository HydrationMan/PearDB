//
//  DeviceGroup.swift
//  PearDBProject
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

struct DeviceGroup: Codable, Identifiable {
    let id: String = UUID().uuidString
    
    var name: String
    var type: String
    var products: [Device]?
    var devices: [String]
    var key: String
}

