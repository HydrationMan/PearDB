//
//  DeviceManager.swift
//  PearDBPortable
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

class DeviceManager {
    var devices: Dictionary<String, [DeviceGroup]>
    var homePage: HomePage
    
    init() {
        //self.fetchDevices()
        print("Init")
        self.devices = Dictionary()
        
        self.homePage = HomePage(deviceTypeCardArray: [], osTypeCardArray: [])
    }
    
    func getAndSortDevices() {

    }
    
    func getGroups(completion: @escaping(Dictionary<String, [DeviceGroup]>) -> Void) {
        
        if self.devices.isEmpty {
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
    
    func getDevices(completion: @escaping(Dictionary<String, [DeviceGroup]>) -> Void) {
        if self.devices.isEmpty {
            Shared.sharedInstance.networkManager.getDevices { devices in
                Shared.sharedInstance.networkManager.getGroups { groups in
                    Shared.sharedInstance.networkManager.getImages { images in
                        
                        var processedGroupArr: [DeviceGroup] = groups
                        
                        processedGroupArr = processedGroupArr.map { x in
                            var group: DeviceGroup = x
                            var products: [Device] = []
                            
                            if let currentDevices = x.devices {
                                for deviceKey in currentDevices {
                                    
                                    if var device = devices.first(where: { $0.key == deviceKey }) {
                                        products.append(device)
                                        if let image = images.first { $0.key == deviceKey } {
                                            device.images = image
                                        }
                                    }
                                    

                                }
                            }
                            group.products = products
                            
                            return group
                        }.compactMap { $0 }
                        
                        var processedGroupsDict: [String: [DeviceGroup]] = [:]
                        //                    print("Found \(processedGroupArr.count) devices ")
                        for group in processedGroupArr {
                            processedGroupsDict[group.type, default: []].append(group)
                            
                            //                        if let products = group.products {
                            //                            for product in products {
                            //                                print("Found \(product.key) for group : \(group.key)")
                            //                            }
                            //                        }
                        }
                        self.devices = processedGroupsDict
                        completion(processedGroupsDict)
                    }
                }
            }
        } else {
            completion(self.devices)
        }
    }
}
