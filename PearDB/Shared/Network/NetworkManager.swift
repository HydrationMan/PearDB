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
        
    func getGroups(completion: @escaping(Devices) -> Void) {
        print("Getting groups...")
        sendGetRequest(url: URL(string:"https://api.appledb.dev/group/main.json")!, completion: {data, response in
            do {
                let groups: [DeviceGroup] = try JSONDecoder().decode([DeviceGroup].self, from: data)
                var devices: Devices = Devices(iPhones: [], watches: [], macs: [], iPads: [], iPods: [], tvs: [], airPods: [], homePods: [], others: [], softwares: [])
                
                for group in groups {
                    switch group.type {
                        case IPHONE_NAME:
                            devices.iPhones.append(group)
                        
                        case MAC_NAME, IMAC_NAME, MBA_NAME, MBP_NAME, MBM_NAME:
                            devices.macs.append(group)
                        
                        case IPOD_TOUCH_NAME:
                            devices.iPods.append(group)
                        
                        case AIRPODS_NAME:
                            devices.airPods.append(group)
                        
                        case IPAD_NAME:
                            devices.iPads.append(group)
                        
                        case APPLETV_NAME:
                            devices.tvs.append(group)
                        
                        case WATCH_NAME:
                            devices.watches.append(group)
                        
                        case HOMEPOD_NAME:
                            devices.homePods.append(group)
                        
                        case SOFTWARE_NAME:
                            devices.softwares.append(group)
                        
                        default :
                            devices.others.append(group)
                    }
                }
                completion(devices)
                
            } catch {
                print("An error occured while attempting parsing groups \(error)")
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
