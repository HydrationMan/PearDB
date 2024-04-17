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
        //self.fetchDevices()
        print("Init")
        self.devices = Devices(iPhones: [], watches: [], macs: [], iPads: [], iPods: [], tvs: [], airPods: [], homePods: [], others: [], softwares: [])
    }
    
    func getAndSortDevices() {

    }
    
    func getGroups(completion: @escaping(Devices) -> Void) {
        
        if self.devices.iPhones.isEmpty {
            Shared.sharedInstance.networkManager.getGroups{ devices in

                self.devices = devices
                completion(devices)
            }
        } else { completion(devices) }
    }
}
