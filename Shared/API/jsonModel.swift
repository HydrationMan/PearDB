//
//  jsonModel.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import Foundation

// Model for main.json or {key}.json response
struct Device: Codable, Identifiable {
    var id: String { key }
    let name: String
    let identifier: [String]?
    let socRaw: SOCType?  // Use a custom enum for handling multiple types
    let cpidRaw: CPIDType?
    let arch: String?
    let type: String?
    let board: [String]?
    let bdid: String?
    let model: [String]?
    let info: [DeviceInfo]?
    let key: String

    let releasedRaw: ReleasedType?
    
    enum CodingKeys: String, CodingKey {
        case name, identifier, socRaw = "soc", cpidRaw = "cpid", arch, type, board, bdid, model, info, key, releasedRaw = "released"
    }

    var soc: String? {
        switch socRaw {
        case .single(let string): return string
        case .array(let strings): return strings.joined(separator: ", ")  // Convert array to string
        case .none: return nil
        }
    }
    
    var released: String? {
        switch releasedRaw {
        case .single(let string): return string
        case .array(let strings): return strings.joined(separator: ", ")
        case .none: return nil
        }
    }
    
    var cpid: String? {
        switch cpidRaw {
        case .single(let string): return string
        case .array(let strings): return strings.joined(separator: ", ")
        case .none: return nil
        }
    }
    
    var deviceType: DeviceType? {
        switch type {
        case "Accessories": return .accessories
        case "Adapters": return .adapters
        case "AirPods": return .airPods
        case "AirPort": return .airPort
        case "AirTag": return .airTag
        case "Apple Pencil": return .applePencil
        case "Apple TV": return .appleTV
        case "Apple Watch": return .appleWatch
        case "Audio": return .audio
        case "Batteries": return .batteries
        case "Beats Earbuds": return .beatsEarbuds
        case "Beats Headphones": return .beatsHeadphones
        case "Beats Speakers": return .beatsSpeakers
        case "Beddit": return .beddit
        case "Bluetooth": return .bluetooth
        case "Cases": return .cases
        case "Compute Module": return .computeModule
        case "Credit Cards": return .creditCards
        case "Display": return .display
        case "Graphics Cards": return .graphicsCards
        case "Headset": return .headset
        case "HomePod": return .homePod
        case "Keyboard": return .keyboard
        case "Mac Pro": return .macPro
        case "Mac Studio": return .macStudio
        case "Mac mini": return .macMini
        case "MacBook": return .macBook
        case "MacBook Air": return .macBookAir
        case "MacBook Pro": return .macBookPro
        case "Macintosh": return .macintosh
        case "Module": return .module
        case "Mouse": return .mouse
        case "Network Card": return .networkCard
        case "Other": return .other
        case "Power": return .power
        case "PowerBook": return .powerBook
        case "PowerMac": return .powerMac
        case "Remote": return .remote
        case "SDK": return .sdk
        case "Security": return .security
        case "Simulator": return .simulator
        case "Software": return .software
        case "Storage": return .storage
        case "Trackpad": return .trackpad
        case "Virtual Machine": return .virtualMachine
        case "Xserve": return .xserve
        case "eMac": return .emac
        case "iBook": return .ibook
        case "iBridge": return .ibridge
        case "iMac": return .imac
        case "iPad": return .ipad
        case "iPad Air": return .ipadAir
        case "iPad Pro": return .ipadPro
        case "iPad mini": return .ipadMini
        case "iPhone": return .iphone
        case "iPod": return .ipod
        case "iPod mini": return .ipodMini
        case "iPod nano": return .ipodNano
        case "iPod shuffle": return .ipodShuffle
        case "iPod touch": return .ipodTouch
        default: return nil
        }
    }

    enum SOCType: Codable {
        case single(String)
        case array([String])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .single(string)
            } else if let strings = try? container.decode([String].self) {
                self = .array(strings)
            } else {
                throw DecodingError.typeMismatch(SOCType.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                    debugDescription: "❌ Invalid type for SOCType"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let string): try container.encode(string)
            case .array(let strings): try container.encode(strings)
            }
        }
    }
    
    enum CPIDType: Codable {
        case single(String)
        case array([String])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .single(string)
            } else if let strings = try? container.decode([String].self) {
                self = .array(strings)
            } else {
                throw DecodingError.typeMismatch(SOCType.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                    debugDescription: "❌ Invalid type for CPIDType"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let string): try container.encode(string)
            case .array(let strings): try container.encode(strings)
            }
        }
    }

    enum ReleasedType: Codable {
        case single(String)
        case array([String])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .single(string)
            } else if let strings = try? container.decode([String].self) {
                self = .array(strings)
            } else {
                throw DecodingError.typeMismatch(ReleasedType.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                    debugDescription: "❌ Invalid type for ReleasedType"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let string): try container.encode(string)
            case .array(let strings): try container.encode(strings)
            }
        }
    }
}

// Model for memory/storage info
struct DeviceInfo: Codable {
    let type: String
    let Storage: String?
    let RAM: String?

    enum CodingKeys: String, CodingKey {
        case type, Storage, RAM
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)

        // Decode Storage as either a String or an Array
        if let storageString = try? container.decode(String.self, forKey: .Storage) {
            Storage = storageString
        } else if let storageArray = try? container.decode([String].self, forKey: .Storage) {
            Storage = storageArray.joined(separator: ", ")
        } else {
            Storage = nil
        }

        // Decode RAM as either a String or an Array
        if let ramString = try? container.decode(String.self, forKey: .RAM) {
            RAM = ramString
        } else if let ramArray = try? container.decode([String].self, forKey: .RAM) {
            RAM = ramArray.joined(separator: ", ")
        } else {
            RAM = nil
        }
    }
}

class DeviceDetailViewModel: ObservableObject {
    @Published var device: Device?
    
    func loadDevice(key: String) {
        AppleDBService().fetchDeviceDetails(for: key) { [weak self] fetchedDevice in
            DispatchQueue.main.async {
                self?.device = fetchedDevice
            }
        }
    }
}

enum DeviceType: String, Codable, CaseIterable {
    case accessories = "Accessories"
    case adapters = "Adapters"
    case airPods = "AirPods"
    case airPort = "AirPort"
    case airTag = "AirTag"
    case applePencil = "Apple Pencil"
    case appleTV = "Apple TV"
    case appleWatch = "Apple Watch"
    case audio = "Audio"
    case batteries = "Batteries"
    case beatsEarbuds = "Beats Earbuds"
    case beatsHeadphones = "Beats Headphones"
    case beatsSpeakers = "Beats Speakers"
    case beddit = "Beddit"
    case bluetooth = "Bluetooth"
    case cases = "Cases"
    case computeModule = "Compute Module"
    case creditCards = "Credit Cards"
    case display = "Display"
    case graphicsCards = "Graphics Cards"
    case headset = "Headset"
    case homePod = "HomePod"
    case keyboard = "Keyboard"
    case macPro = "Mac Pro"
    case macStudio = "Mac Studio"
    case macMini = "Mac mini"
    case macBook = "MacBook"
    case macBookAir = "MacBook Air"
    case macBookPro = "MacBook Pro"
    case macintosh = "Macintosh"
    case module = "Module"
    case mouse = "Mouse"
    case networkCard = "Network Card"
    case other = "Other"
    case power = "Power"
    case powerBook = "PowerBook"
    case powerMac = "PowerMac"
    case remote = "Remote"
    case sdk = "SDK"
    case security = "Security"
    case simulator = "Simulator"
    case software = "Software"
    case storage = "Storage"
    case trackpad = "Trackpad"
    case virtualMachine = "Virtual Machine"
    case xserve = "Xserve"
    case emac = "eMac"
    case ibook = "iBook"
    case ibridge = "iBridge"
    case iphone = "iPhone"
    case imac = "iMac"
    case ipad = "iPad"
    case ipadAir = "iPad Air"
    case ipadPro = "iPad Pro"
    case ipadMini = "iPad mini"
    case ipod = "iPod"
    case ipodMini = "iPod mini"
    case ipodNano = "iPod nano"
    case ipodShuffle = "iPod shuffle"
    case ipodTouch = "iPod touch"
}
