//
//  Shared.swift
//  PearDBProject
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

class Shared {
    static let sharedInstance: Shared = Shared()
    var deviceManager: DeviceManager
    var networkManager: NetworkManager
    
    init() {
        
        print("Loading Shared instance....")
        self.deviceManager = DeviceManager()
        self.networkManager = NetworkManager()

    }
}
