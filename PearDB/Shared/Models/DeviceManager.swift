//
//  DeviceManager.swift
//  PearDBPortable
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

class DeviceManager {
    var devices: Devices
    var homePage: HomePage
    
    init() {
        //self.fetchDevices()
        print("Init")
        self.devices = Devices(iPhones: [], watches: [], macs: [], iPads: [], iPods: [], tvs: [], airPods: [], homePods: [], others: [], softwares: [])
        
        self.homePage = HomePage(deviceTypeCardArray: [], osTypeCardArray: [])
    }
    
    func getAndSortDevices() {

    }
    
    func getGroups(completion: @escaping(Devices) -> Void) {
        
        if self.devices.iPhones.isEmpty {
            Shared.sharedInstance.networkManager.getGroups{ devices in

                //self.devices = devices
                //completion(devices)
            }
        } else { completion(devices) }
    }
    
    func getHomePage(completion: @escaping(HomePage) -> Void) {
        if self.homePage.osTypeCardArray.isEmpty {
            Shared.sharedInstance.networkManager.getHomePage { data in
                self.homePage = data
                completion(data)
            }
        } else {
            completion(self.homePage)
        }
    }
    
    func getDevices(completion: @escaping(Devices) -> Void) {
//        if self.devices.iPhones.isEmpty {
//            Shared.sharedInstance.networkManager.getDevices { devices in
//                Shared.sharedInstance.networkManager.getGroups { groups in
//                    var tempDevices: [Device] = devices
//                    var tempGroups: [DeviceGroup] = []
//                    for group in groups {
//                        group.products = []
//                        for tempDevice in tempDevices {
//                                if group.devices.contains(tempDevice.key) {
//
//                                    tempGroups.append(group.products?.append(tempDevice))
//                                    tempDevices.remove(tempDevice)
//                                }
//                        }
//                        print($0)
//                    }
//                }
//            }
//        } else {
//            completion(self.devices)
//        }
    }
}
