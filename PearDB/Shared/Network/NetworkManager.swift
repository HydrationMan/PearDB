//
//  NetworkManager.swift
//  PearDBProject
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

class NetworkManager {
    func sendGetRequest(url: URL, completion: @escaping (Data, HTTPURLResponse?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
//            if error != nil {
//                // Display popup fr
//            } else
            if let data = data {
                completion(data, (response as! HTTPURLResponse))
            }
        }.resume()
    }
        
    func getGroups() {
        sendGetRequest(url: URL(string:"https://api.appledb.dev/group/main.json")!, completion: {data, response in
            do {
                let groups: [DeviceGroup] = try JSONDecoder().decode([DeviceGroup].self, from: data)
                
                for group in groups {
                    switch group.type {
                        case IPHONE_NAME:
                            Shared.sharedInstance.deviceManager.devices.iPhones.append(group)
                        
                        case MAC_NAME:
                            Shared.sharedInstance.deviceManager.devices.macs.append(group)
                        
                        case IPOD_NAME:
                            Shared.sharedInstance.deviceManager.devices.iPods.append(group)
                        
                        case AIRPODS_NAME:
                            Shared.sharedInstance.deviceManager.devices.airPods.append(group)
                        
                        case IPAD_NAME:
                            Shared.sharedInstance.deviceManager.devices.iPads.append(group)
                        
                        case APPLETV_NAME:
                            Shared.sharedInstance.deviceManager.devices.tvs.append(group)
                        
                        case WATCH_NAME:
                            Shared.sharedInstance.deviceManager.devices.watches.append(group)
                        
                        case HOMEPOD_NAME:
                            Shared.sharedInstance.deviceManager.devices.homePods.append(group)
                        
                        case SOFTWARE_NAME:
                            Shared.sharedInstance.deviceManager.devices.softwares.append(group)
                        
                        default :
                            Shared.sharedInstance.deviceManager.devices.others.append(group)
                    }
                }
            } catch {
                print("An error occured while attempting parsing groups")
            }
        })
    }
    
    func getDevices() {
        sendGetRequest(url: URL(string:"https://api.appledb.dev/device/main.json")!, completion: {data, response in
            do {
                let devices: [Device] = try JSONDecoder().decode([Device].self, from: data)
                
                for device in devices {
                    
                }
            } catch {
                print("An error occured while attempting to deserialize the data !")
            }
        })
    }
}
