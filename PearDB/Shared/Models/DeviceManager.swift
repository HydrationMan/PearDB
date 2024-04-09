//
//  DeviceManager.swift
//  PearDBPortable
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

class DeviceManager {
    var devices: Devices
    
    init() {
        self.fetchDevices()
    }
    
    func getAndSortDevices() {

    }
    
    func fetchDevices() {
        devices = Devices(iPhones: Shared.sharedInstance.deviceManager.,
                          watches: <#T##[WatchGroup]#>,
                          macs: <#T##[MacGroup]#>,
                          iPads: <#T##[iPadGroup]#>,
                          tvs: <#T##[AppleTVGroup]#>,
                          airPods: <#T##[AirPodsGroup]#>,
                          homePods: <#T##[HomePods]#>)
    }
}
