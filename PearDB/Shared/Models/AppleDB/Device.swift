//
//  AppleDBDevices.swift
//  PearDBProject
//
//  Created by bibi_fire on 07/04/2024.
//

import Foundation

extension KeyedDecodingContainer {
    public func decodeVal(forKey key: KeyedDecodingContainer<K>.Key) throws -> [String]? {
        
        if let container = try? self.decode([String].self, forKey: key) {
            return container
        } else if let val = try? self.decode(String.self, forKey: key) {
            return [val]
        } else {
            return nil
        }
    }
}

struct Device: Codable {
    let id: String = UUID().uuidString
    
    var name: String
    var type: String
    var model: [String]
    var key: String
    var released: [String]?
    var identifier: [String]
    var soc: String?
    var arch: String?
    var board: [String]?
    var info: DeviceInfo?
    var alias: [String]?
    var iBridge: String?
    var group: Bool?
    var windowsStoreId: String?
    var discontinued: String?
    var images: DeviceImageList?
    
    struct ArrayOrString : Codable {
        var released: [String]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.model = try container.decode([String].self, forKey: .model)
        self.key = try container.decode(String.self, forKey: .key)
        self.identifier = try container.decode([String].self, forKey: .identifier)
        self.released = try container.decodeVal(forKey: .released)
        self.soc = try? container.decode(String.self, forKey: .soc)
        self.arch = try? container.decode(String.self, forKey: .arch)
        self.board = try? container.decode([String].self, forKey: .board)
        self.info = try? container.decode(DeviceInfo.self, forKey: .info)
        self.alias = try? container.decode([String].self, forKey: .alias)
        self.iBridge = try? container.decode(String.self, forKey: .iBridge)
        self.group = try? container.decode(Bool.self, forKey: .group)
        self.windowsStoreId = try? container.decode(String.self, forKey: .windowsStoreId)
        self.discontinued = try? container.decode(String.self, forKey: .discontinued)
    }
    
}

struct DeviceInfo: Codable {
    var type: String
    var wifi: String?
    var Frequency: String?
    var Storage: [String]?
    var RAM: String?
    var dataThroughput: String?
    var Interfaces: [String]?
    var Security: [String]?
    var MiMO: String?
    var concurrentDevices: String?
    var flashMemory: String?
    var CPU: String?
    var Resolution: DisplayResolution?
    var screenSize: String?
    var refreshRate: String?
    var peakBrightness: String
    var trueTone: Bool
    var ppi: Int
    
    private enum CodingKeys: String, CodingKey {
        case type
        case wifi = "Wi-Fi"
        case Frequency
        case Storage
        case RAM
        case dataThroughput = "Data Throughput"
        case Interfaces
        case Security
        case MiMO
        case concurrentDevices
        case flashMemory = "Flash Memory"
        case CPU
        case Resolution
        case screenSize = "Screen_Size"
        case refreshRate = "Refresh_Rate"
        case peakBrightness = "Peak_Brightness"
        case trueTone = "True_Tone"
        case ppi = "Pixels_per_Inch"
    }
}

struct DisplayResolution: Codable {
    var x: Int
    var y: Int
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}

struct DeviceImageList : Codable {
    var key: String
    var count: Int
    var dark: Bool
    var index: [DeviceImage]
}

struct DeviceImage : Codable, Identifiable {   
    var id: Int
    var dark: Bool
}
