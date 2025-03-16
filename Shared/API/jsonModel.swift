//
//  jsonModel.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import Foundation
import Combine

// Model for main.json or {key}.json response
class Device: ObservableObject, Codable, Identifiable {
    var id: String { key }
    @Published private(set) var name: String
    @Published private(set) var identifierRaw: IdentifierType?
    @Published private(set) var socRaw: SOCType?
    @Published private(set) var cpidRaw: CPIDType?
    @Published private(set) var arch: String?
    @Published private(set) var type: String?
    @Published private(set) var board: [String]?
    @Published private(set) var bdid: String?
    @Published private(set) var model: [String]?
    @Published private(set) var info: [DeviceInfo]?
    @Published private(set) var key: String
    @Published private(set) var releasedRaw: ReleasedType?
    @Published var imageUrl: [String] = []
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        identifierRaw = try container.decodeIfPresent(IdentifierType.self, forKey: .identifierRaw)
        socRaw = try container.decodeIfPresent(SOCType.self, forKey: .socRaw)
        cpidRaw = try container.decodeIfPresent(CPIDType.self, forKey: .cpidRaw)
        arch = try container.decodeIfPresent(String.self, forKey: .arch)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        board = try container.decodeIfPresent([String].self, forKey: .board)
        bdid = try container.decodeIfPresent(String.self, forKey: .bdid)
        model = try container.decodeIfPresent([String].self, forKey: .model)
        info = try container.decodeIfPresent([DeviceInfo].self, forKey: .info)
        key = try container.decode(String.self, forKey: .key)
        releasedRaw = try container.decodeIfPresent(ReleasedType.self, forKey: .releasedRaw)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(identifierRaw, forKey: .identifierRaw)
        try container.encodeIfPresent(socRaw, forKey: .socRaw)
        try container.encodeIfPresent(cpidRaw, forKey: .cpidRaw)
        try container.encodeIfPresent(arch, forKey: .arch)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(board, forKey: .board)
        try container.encodeIfPresent(bdid, forKey: .bdid)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(info, forKey: .info)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(releasedRaw, forKey: .releasedRaw)
    }

    
    enum CodingKeys: String, CodingKey {
        case name, identifierRaw = "identifier", socRaw = "soc", cpidRaw = "cpid", arch, type, board, bdid, model, info, key, releasedRaw = "released"
    }

    var soc: String? {
        switch socRaw {
        case .single(let string): return string
        case .array(let strings): return strings.joined(separator: ", ")  // Convert array to string
        case .none: return nil
        }
    }
    
    var identifier: String? {
        switch identifierRaw {
        case .single(let string):
            return string
        case .array(let array):
            return array.joined(separator: ", ")
        case nil:
            return nil
        }
    }
    
    var released: String? {
        switch releasedRaw {
        case .single(let string): return string
        case .array(let strings): return strings.joined(separator: ", ")
        case .none: return nil
        }
    }
    
    var releasedDateType: Date? {
        switch releasedRaw {
        case .single(let string):
            let dateFormatter = DateFormatter()
            let dateFormat = "yyyy-MM-dd"
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.date(from: string)
        default:
            return nil
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
    
    var deviceGroup: DeviceGroupType? {
        switch deviceType {
        case .accessories:
            return .homeAndAccessories
        case .adapters:
            return .homeAndAccessories
        case .airPods:
            return .audio
        case .airPort:
            return .homeAndAccessories
        case .airTag:
            return .homeAndAccessories
        case .applePencil:
            return .inputs
        case .appleTV:
            return .homeAndAccessories
        case .appleWatch:
            return .homeAndAccessories
        case .audio:
            return .audio
        case .beatsEarbuds:
            return .audio
        case .beatsHeadphones:
            return .audio
        case .beatsSpeakers:
            return .audio
        case .beddit:
            return .homeAndAccessories
        case .bluetooth:
            return .homeAndAccessories
        case .cases:
            return .homeAndAccessories
        case .display:
            return .homeAndAccessories
        case .headset:
            return .homeAndAccessories
        case .homePod:
            return .audio
        case .keyboard:
            return .inputs
        case .macPro:
            return .macs
        case .macStudio:
            return .macs
        case .macMini:
            return .macs
        case .macBook:
            return .macs
        case .macBookAir:
            return .macs
        case .macBookPro:
            return .macs
        case .macintosh:
            return .macs
        case .mouse:
            return .inputs
        case .power:
            return .homeAndAccessories
        case .powerBook:
            return .macs
        case .powerMac:
            return .macs
        case .remote:
            return .inputs
        case .trackpad:
            return .inputs
        case .xserve:
            return .macs
        case .emac:
            return .macs
        case .ibook:
            return .macs
        case .iphone:
            return .iOSDevices
        case .imac:
            return .macs
        case .ipad:
            return .iOSDevices
        case .ipadAir:
            return .iOSDevices
        case .ipadPro:
            return .iOSDevices
        case .ipadMini:
            return .iOSDevices
        case .ipod:
            return .iPods
        case .ipodMini:
            return .iPods
        case .ipodNano:
            return .iPods
        case .ipodShuffle:
            return .iPods
        case .ipodTouch:
            return .iPods
        default:
            return nil
        }
    }
    
    enum IdentifierType: Codable {
        case single(String)
        case array([String])
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .single(string)
            } else if let strings = try? container.decode([String].self) {
                self = .array(strings)
            } else {
                throw DecodingError.typeMismatch(SOCType.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                    debugDescription: "❌ Invalid type for IdentifierType"))
            }
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
    
    // Type SoC
    let soc: String?
    let architecture: String?
    let manifacturingProcess: String?
    
    // Type Cores
    let cpuCoreCount: String?
    let performanceCores: String?
    let efficiencyCores: String?
    let gpuCoreCount: String?
    let neuralEngineCoreCount: String?
    
    // Type Memory
    let storage: String?
    let ram: String?
    
    // Type Power
    let batteryCapacity: String?
    let batteryLife: String?
    let charger: String?
    
    // Type Connectivity
    let ports: String?
    let cellular: String?
    let wifi: String?
    let bluetooth: String?
    let ultraWideBand: String?
    let supports: String?
    let externalDisplayCount: String?
    
    // Type sensors
    let camera: String?
    let frontCamera: String?
    let telephotoCamera: String?
    let wideCamera: String?
    let ultraWideCamera: String?
    let trueDepthCamera: String?
    let biometrics: String?
    let other: String?
    
    // Type Audio
    let channels: String?
    let speakers: String?
    let dolbyAtmos: String?
    let headphoneJack: String?
    let microphone: String?
    
    // Type Display
    let resolution: Resolution?
    let screenSize: String?
    let refreshRate: String?
    let peakBrightness: String?
    let colorGamut: String?
    let trueTone: String?
    let proMotion: String?
    let ppi: String?
    
    // Type Input
    let keyCount: String?
    let trackpad: String?
    let touchbar: String?
    let touchId: String?

    enum CodingKeys: String, CodingKey {
        case type, soc = "SoC", architecture = "Architecture", manifacturingProcess = "Manufacturing_Process", cpuCoreCount = "CPU_Core_Count", performanceCores = "Performance_Cores", efficiencyCores = "Efficiency_Cores", gpuCoreCount = "GPU_Core_Count", neuralEngineCoreCount = "Neural_Engine_Core_Count", storage = "Storage", ram = "RAM", batteryCapacity = "Battery_Capacity", batteryLife = "Battery_Life", charger = "Charger", ports = "Ports", cellular = "Cellular", wifi = "Wi-Fi", bluetooth = "Bluetooth", ultraWideBand = "Ultra-wideband", frontCamera = "Front_Camera", telephotoCamera = "Telephoto_Camera", wideCamera = "Wide_Camera", ultraWideCamera = "Ultrawide_Camera", trueDepthCamera = "TrueDepth_Camera", biometrics = "Biometrics", other = "Other", channels = "Channels", headphoneJack = "Headphone_Jack", microphone = "Microphone", resolution = "Resolution", screenSize = "Screen_Size", refreshRate = "Refresh_Rate", peakBrightness = "Peak_Brightness", colorGamut = "Color_Gamut", trueTone = "True_Tone", proMotion = "ProMotion", ppi = "Pixels_per_Inch", speakers = "Speakers", dolbyAtmos = "Dolby_Atmos", camera = "Camera", keyCount = "Key_Count", trackpad = "Trackpad", touchbar = "Touch_Bar", touchId = "Touch_ID", supports = "Supports", externalDisplayCount = "External_Display_Count"
    }
    
    var deviceInfoType: DeviceInfoType? {
        switch type {
        case "SoC": return .soc
        case "Cores": return .cores
        case "Memory": return .memory
        case "Connectivity": return .connectivity
        case "Power": return .power
        case "Sensors": return .sensors
        case "Audio": return .audio
        case "Storage": return .storage
        case "Display": return .display
        case "Input": return .input
        default: return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        resolution = try container.decodeIfPresent(Resolution.self, forKey: .resolution)
        
        if let supportsString = try? container.decodeIfPresent(String.self, forKey: .supports) {
            supports = supportsString
        } else if let supportsArray = try? container.decodeIfPresent([String].self, forKey: .supports) {
            supports = supportsArray.joined(separator: ", ")
        } else {
            supports = nil
        }
        
        if let externalDisplayCountInt = try? container.decodeIfPresent(Int.self, forKey: .externalDisplayCount) {
            externalDisplayCount = externalDisplayCountInt.description
        } else if let externalDisplayCountArray = try? container.decodeIfPresent([Int].self, forKey: .externalDisplayCount) {
            externalDisplayCount = externalDisplayCountArray.map { $0.description }.joined(separator: ", ")
        } else {
            externalDisplayCount = nil
        }
        
        if let ppiInt = try? container.decodeIfPresent(Int.self, forKey: .ppi) {
            ppi = ppiInt.description
        } else if let ppiArray = try? container.decodeIfPresent([Int].self, forKey: .ppi) {
            ppi = ppiArray.map { "\($0)" }.joined(separator: ", ")
        } else {
            ppi = nil
        }
        
        if let cpuCoreCountInt = try? container.decodeIfPresent(Int.self, forKey: .cpuCoreCount) {
            cpuCoreCount = cpuCoreCountInt.description
        } else if let cpuCoreCountArray = try? container.decodeIfPresent([Int].self, forKey: .cpuCoreCount) {
            cpuCoreCount = cpuCoreCountArray.map { "\($0)" }.joined(separator: ", ")
        } else {
            cpuCoreCount = nil
        }
        
        if let gpuCoreCountInt = try? container.decodeIfPresent(Int.self, forKey: .gpuCoreCount) {
            gpuCoreCount = gpuCoreCountInt.description
        } else if let gpuCoreCountArray = try? container.decodeIfPresent([Int].self, forKey: .gpuCoreCount) {
            gpuCoreCount = gpuCoreCountArray.map { "\($0)" }.joined(separator: ", ")
        } else {
            gpuCoreCount = nil
        }
        
        if let neuralEngineCoreCountInt = try? container.decodeIfPresent(Int.self, forKey: .neuralEngineCoreCount) {
            neuralEngineCoreCount = neuralEngineCoreCountInt.description
        } else if let neuralEngineCoreCountArray = try? container.decodeIfPresent([Int].self, forKey: .gpuCoreCount) {
            neuralEngineCoreCount = neuralEngineCoreCountArray.map { "\($0)" }.joined(separator: ", ")
        } else {
            neuralEngineCoreCount = nil
        }
        
        if let ultraWideBandBool = try? container.decodeIfPresent(Bool.self, forKey: .ultraWideBand) {
            ultraWideBand = ultraWideBandBool ? "Yes" : "No"
        } else {
            ultraWideBand = nil
        }
        
        if let touchbarBool = try? container.decodeIfPresent(Bool.self, forKey: .touchbar) {
            touchbar = touchbarBool ? "Yes" : "No"
        } else {
            touchbar = nil
        }
        
        if let touchIdBool = try? container.decodeIfPresent(Bool.self, forKey: .touchId) {
            touchId = touchIdBool ? "Yes" : "No"
        } else {
            touchId = nil
        }
        
        if let headphoneJackBool = try? container.decodeIfPresent(Bool.self, forKey: .headphoneJack) {
            headphoneJack = headphoneJackBool ? "Yes" : "No"
        } else if let headphoneJackString = try? container.decodeIfPresent(String.self, forKey: .headphoneJack) {
            headphoneJack = headphoneJackString
        } else {
            headphoneJack = nil
        }
        
        if let microphoneBool = try? container.decodeIfPresent(Bool.self, forKey: .microphone) {
            microphone = microphoneBool ? "Yes" : "No"
        } else if let microphoneString = try? container.decodeIfPresent(String.self, forKey: .microphone) {
            microphone = microphoneString
        } else {
            microphone = nil
        }
        
        if let speakerString = try? container.decodeIfPresent(String.self, forKey: .speakers) {
            speakers = speakerString
        } else if let speakerArray = try? container.decodeIfPresent([String].self, forKey: .speakers) {
            speakers = speakerArray.joined(separator: ", ")
        } else {
            speakers = nil
        }
        
        if let dolbyAtmosBool = try? container.decodeIfPresent(Bool.self, forKey: .dolbyAtmos) {
            dolbyAtmos = dolbyAtmosBool ? "Yes" : "No"
        } else {
            dolbyAtmos = nil
        }
        
        if let trueToneBool = try? container.decodeIfPresent(Bool.self, forKey: .trueTone) {
            trueTone = trueToneBool ? "Yes" : "No"
        } else {
            trueTone = nil
        }
        
        if let proMotionBool = try? container.decodeIfPresent(Bool.self, forKey: .proMotion) {
            proMotion = proMotionBool ? "Yes" : "No"
        } else {
            proMotion = nil
        }
        
        // Decode SoC as either a String or an Array
        if let socString = try? container.decodeIfPresent(String.self, forKey: .soc) {
            soc = socString
        } else if let socArray = try? container.decodeIfPresent([String].self, forKey: .soc) {
            soc = socArray.joined(separator: ", ")
        } else {
            soc = nil
        }
        
        // Decode Architecture as either a String or an Array
        if let architectureString = try? container.decodeIfPresent(String.self, forKey: .architecture) {
            architecture = architectureString
        } else if let architectureArray = try? container.decodeIfPresent([String].self, forKey: .architecture) {
            architecture = architectureArray.joined(separator: ", ")
        } else {
            architecture = nil
        }
        
        // Decode Manifacturing Process as either a String or an Array
        if let manifacturingProcessString = try? container.decodeIfPresent(String.self, forKey: .manifacturingProcess) {
            manifacturingProcess = manifacturingProcessString
        } else if let manifacturingProcessArray = try? container.decodeIfPresent([String].self, forKey: .manifacturingProcess) {
            manifacturingProcess = manifacturingProcessArray.joined(separator: ", ")
        } else {
            manifacturingProcess = nil
        }
        
        // Decode Performance Cores as either a String or an Array
        if let performanceCoresString = try? container.decodeIfPresent(String.self, forKey: .performanceCores) {
            performanceCores = performanceCoresString
        } else if let performanceCoresArray = try? container.decodeIfPresent([String].self, forKey: .performanceCores) {
            performanceCores = performanceCoresArray.joined(separator: ", ")
        } else {
            performanceCores = nil
        }
        
        // Decode Efficiency Cores as either a String or an Array
        if let efficiencyCoresString = try? container.decodeIfPresent(String.self, forKey: .efficiencyCores) {
            efficiencyCores = efficiencyCoresString
        } else if let efficiencyCoresArray = try? container.decodeIfPresent([String].self, forKey: .efficiencyCores) {
            efficiencyCores = efficiencyCoresArray.joined(separator: ", ")
        } else {
            efficiencyCores = nil
        }

        // Decode Storage as either a String or an Array
        if let storageString = try? container.decodeIfPresent(String.self, forKey: .storage) {
            storage = storageString
        } else if let storageArray = try? container.decodeIfPresent([String].self, forKey: .storage) {
            storage = storageArray.joined(separator: ", ")
        } else {
            storage = nil
        }

        // Decode RAM as either a String or an Array
        if let ramString = try? container.decodeIfPresent(String.self, forKey: .ram) {
            ram = ramString
        } else if let ramArray = try? container.decodeIfPresent([String].self, forKey: .ram) {
            ram = ramArray.joined(separator: ", ")
        } else {
            ram = nil
        }
        
        // Decode Battery Capacity as either a String or an Array
        if let batteryCapacityString = try? container.decodeIfPresent(String.self, forKey: .batteryCapacity) {
            batteryCapacity = batteryCapacityString
        } else if let batteryCapacityArray = try? container.decodeIfPresent([String].self, forKey: .batteryCapacity) {
            batteryCapacity = batteryCapacityArray.joined(separator: ", ")
        } else {
            batteryCapacity = nil
        }
        
        // Decode Battery Life as either a String or an Array
        if let batteryLifeString = try? container.decodeIfPresent(String.self, forKey: .batteryLife) {
            batteryLife = batteryLifeString
        } else if let batteryLifeArray = try? container.decodeIfPresent([String].self, forKey: .batteryLife) {
            batteryLife = batteryLifeArray.joined(separator: ", ")
        } else {
            batteryLife = nil
        }
        
        // Decode Charger as either a String or an Array
        if let chargerString = try? container.decodeIfPresent(String.self, forKey: .charger) {
            charger = chargerString
        } else if let chargerArray = try? container.decodeIfPresent([String].self, forKey: .charger) {
            charger = chargerArray.joined(separator: ", ")
        } else {
            charger = nil
        }
        
        // Decode Ports as either a String or an Array
        if let portsString = try? container.decodeIfPresent(String.self, forKey: .ports) {
            ports = portsString
        } else if let portsArray = try? container.decodeIfPresent([String].self, forKey: .ports) {
            ports = portsArray.joined(separator: ", ")
        } else {
            ports = nil
        }
        
        // Decode Cellular as either a String or an Array
        if let cellularString = try? container.decodeIfPresent(String.self, forKey: .cellular) {
            cellular = cellularString
        } else if let cellularArray = try? container.decodeIfPresent([String].self, forKey: .cellular) {
            cellular = cellularArray.joined(separator: ", ")
        } else {
            cellular = nil
        }
        
        // Decode Wifi as either a String or an Array
        if let wifiString = try? container.decodeIfPresent(String.self, forKey: .wifi) {
            wifi = wifiString
        } else if let wifiArray = try? container.decodeIfPresent([String].self, forKey: .wifi) {
            wifi = wifiArray.joined(separator: ", ")
        } else {
            wifi = nil
        }
        
        // Decode Bluetooth as either a String or an Array
        if let bluetoothString = try? container.decodeIfPresent(String.self, forKey: .bluetooth) {
            bluetooth = bluetoothString
        } else if let bluetoothArray = try? container.decodeIfPresent([String].self, forKey: .bluetooth) {
            bluetooth = bluetoothArray.joined(separator: ", ")
        } else {
            bluetooth = nil
        }
        
        // Decode Front Camera as either a String or an Array
        if let frontCameraString = try? container.decodeIfPresent(String.self, forKey: .frontCamera) {
            frontCamera = frontCameraString
        } else if let frontCameraArray = try? container.decodeIfPresent([String].self, forKey: .frontCamera) {
            frontCamera = frontCameraArray.joined(separator: ", ")
        } else {
            frontCamera = nil
        }
        
        // Decode Front Camera as either a String or an Array
        if let telephotoCameraString = try? container.decodeIfPresent(String.self, forKey: .telephotoCamera) {
            telephotoCamera = telephotoCameraString
        } else if let telephotoCameraArray = try? container.decodeIfPresent([String].self, forKey: .telephotoCamera) {
            telephotoCamera = telephotoCameraArray.joined(separator: ", ")
        } else {
            telephotoCamera = nil
        }
        
        // Decode Wide Camera as either a String or an Array
        if let wideCameraString = try? container.decodeIfPresent(String.self, forKey: .wideCamera) {
            wideCamera = wideCameraString
        } else if let wideCameraArray = try? container.decodeIfPresent([String].self, forKey: .wideCamera) {
            wideCamera = wideCameraArray.joined(separator: ", ")
        } else {
            wideCamera = nil
        }
        
        // Decode Ultra wide Camera as either a String or an Array
        if let ultraWideCameraString = try? container.decodeIfPresent(String.self, forKey: .ultraWideCamera) {
            ultraWideCamera = ultraWideCameraString
        } else if let ultraWideCameraArray = try? container.decodeIfPresent([String].self, forKey: .ultraWideCamera) {
            ultraWideCamera = ultraWideCameraArray.joined(separator: ", ")
        } else {
            ultraWideCamera = nil
        }
        
        // Decode True depth Camera as either a String or an Array
        if let trueDepthCameraString = try? container.decodeIfPresent(String.self, forKey: .trueDepthCamera) {
            trueDepthCamera = trueDepthCameraString
        } else if let trueDepthCameraArray = try? container.decodeIfPresent([String].self, forKey: .trueDepthCamera) {
            trueDepthCamera = trueDepthCameraArray.joined(separator: ", ")
        } else {
            trueDepthCamera = nil
        }
        
        // Decode Biometrics as either a String or an Array
        if let biometricsString = try? container.decodeIfPresent(String.self, forKey: .biometrics) {
            biometrics = biometricsString
        } else if let biometricsArray = try? container.decodeIfPresent([String].self, forKey: .biometrics) {
            biometrics = biometricsArray.joined(separator: ", ")
        } else {
            biometrics = nil
        }
        
        // Decode Other as either a String or an Array
        if let otherString = try? container.decodeIfPresent(String.self, forKey: .other) {
            other = otherString
        } else if let otherArray = try? container.decodeIfPresent([String].self, forKey: .other) {
            other = otherArray.joined(separator: ", ")
        } else {
            other = nil
        }
        
        // Decode Channels as either a String or an Array
        if let channelsString = try? container.decodeIfPresent(String.self, forKey: .channels) {
            channels = channelsString
        } else if let channelsArray = try? container.decodeIfPresent([String].self, forKey: .channels) {
            channels = channelsArray.joined(separator: ", ")
        } else {
            channels = nil
        }
        
        // Decode Screen Size as either a String or an Array
        if let screenSizeString = try? container.decodeIfPresent(String.self, forKey: .screenSize) {
            screenSize = screenSizeString
        } else if let screenSizeArray = try? container.decodeIfPresent([String].self, forKey: .screenSize) {
            screenSize = screenSizeArray.joined(separator: ", ")
        } else {
            screenSize = nil
        }
        
        // Decode Refresh Rate as either a String or an Array
        if let refreshRateString = try? container.decodeIfPresent(String.self, forKey: .refreshRate) {
            refreshRate = refreshRateString
        } else if let refreshRateArray = try? container.decodeIfPresent([String].self, forKey: .refreshRate) {
            refreshRate = refreshRateArray.joined(separator: ", ")
        } else {
            refreshRate = nil
        }
        
        // Decode Peak Brightness as either a String or an Array
        if let peakBrightnessString = try? container.decodeIfPresent(String.self, forKey: .peakBrightness) {
            peakBrightness = peakBrightnessString
        } else if let peakBrightnessArray = try? container.decodeIfPresent([String].self, forKey: .peakBrightness) {
            peakBrightness = peakBrightnessArray.joined(separator: ", ")
        } else {
            peakBrightness = nil
        }
        
        // Decode Peak Brightness as either a String or an Array
        if let colorGamutString = try? container.decodeIfPresent(String.self, forKey: .colorGamut) {
            colorGamut = colorGamutString
        } else if let colorGamutArray = try? container.decodeIfPresent([String].self, forKey: .colorGamut) {
            colorGamut = colorGamutArray.joined(separator: ", ")
        } else {
            colorGamut = nil
        }
        
        // Decode Camera as either a String or an Array
        if let cameraString = try? container.decodeIfPresent(String.self, forKey: .camera) {
            camera = cameraString
        } else if let cameraArray = try? container.decodeIfPresent([String].self, forKey: .camera) {
            camera = cameraArray.joined(separator: ", ")
        } else {
            camera = nil
        }
        
        // Decode Key Count as either a String or an Array
        if let keyCountString = try? container.decodeIfPresent(String.self, forKey: .keyCount) {
            keyCount = keyCountString
        } else if let keyCountArray = try? container.decodeIfPresent([String].self, forKey: .keyCount) {
            keyCount = keyCountArray.joined(separator: ", ")
        } else {
            keyCount = nil
        }
        
        // Decode Trackpad as either a String or an Array
        if let trackpadString = try? container.decodeIfPresent(String.self, forKey: .trackpad) {
            trackpad = trackpadString
        } else if let trackpadArray = try? container.decodeIfPresent([String].self, forKey: .trackpad) {
            trackpad = trackpadArray.joined(separator: ", ")
        } else {
            trackpad = nil
        }
    }
}

struct Resolution: Codable {
    let x: Int?
    let y: Int?
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

enum DeviceInfoType: String, Codable, CaseIterable {
    case soc = "SoC"
    case cores = "Cores"
    case memory = "Memory"
    case power = "Power"
    case connectivity = "Connectivity"
    case sensors = "Sensors"
    case audio = "Audio"
    case storage = "Storage"
    case display = "Display"
    case input = "Input"
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

class Firmware: ObservableObject, Identifiable, Codable {
    var id: String { key }
    @Published private(set) var osStr: String
    @Published private(set) var version: String
    @Published private(set) var restoreVersion: String?
    @Published private(set) var beta: Bool?
    @Published private(set) var rsr: Bool?
    @Published private(set) var build: String?
    @Published private(set) var key: String
    @Published private(set) var releasedRaw: String?
    @Published private(set) var appledburl: String
    @Published private(set) var deviceMap: [String]
    @Published private(set) var releaseNotesUrl: String?
    @Published private(set) var securityNotesUrl: String?
    @Published private(set) var sources: [FirmwareSources]?
    @Published private(set) var rc: Bool?
    @Published var state: State = .idle
    private(set) var currentBytes: Int64 = 0
    private(set) var totalBytes: Int64 = 0

    enum CodingKeys: String, CodingKey {
        case osStr, version, build, key, releasedRaw = "released", appledburl, deviceMap
        case restoreVersion, beta, rsr, releaseNotesUrl = "releaseNotes"
        case securityNotesUrl = "securityNotes", sources, rc
    }
    
    enum State: Equatable {
        case idle
        case dowloading
        case completed
        case canceled(resumeData: Data)
    }
    
    var progress: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(currentBytes) / Double(totalBytes)
    }

    var isDownloadCompleted: Bool {
        currentBytes == totalBytes && totalBytes > 0
    }
    
    var released: String? {
        return releasedRaw
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        osStr = try container.decode(String.self, forKey: .osStr)
        version = try container.decode(String.self, forKey: .version)
        restoreVersion = try container.decodeIfPresent(String.self, forKey: .restoreVersion)
        beta = try container.decodeIfPresent(Bool.self, forKey: .beta)
        rsr = try container.decodeIfPresent(Bool.self, forKey: .rsr)
        build = try container.decodeIfPresent(String.self, forKey: .build)
        key = try container.decode(String.self, forKey: .key)
        releasedRaw = try container.decodeIfPresent(String.self, forKey: .releasedRaw)
        appledburl = try container.decode(String.self, forKey: .appledburl)
        deviceMap = try container.decode([String].self, forKey: .deviceMap)
        releaseNotesUrl = try container.decodeIfPresent(String.self, forKey: .releaseNotesUrl)
        securityNotesUrl = try container.decodeIfPresent(String.self, forKey: .securityNotesUrl)
        sources = try container.decodeIfPresent([FirmwareSources].self, forKey: .sources)
        rc = try container.decodeIfPresent(Bool.self, forKey: .rc)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(osStr, forKey: .osStr)
        try container.encode(version, forKey: .version)
        try container.encodeIfPresent(restoreVersion, forKey: .restoreVersion)
        try container.encodeIfPresent(beta, forKey: .beta)
        try container.encodeIfPresent(rsr, forKey: .rsr)
        try container.encodeIfPresent(build, forKey: .build)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(releasedRaw, forKey: .releasedRaw)
        try container.encode(appledburl, forKey: .appledburl)
        try container.encode(deviceMap, forKey: .deviceMap)
        try container.encodeIfPresent(releaseNotesUrl, forKey: .releaseNotesUrl)
        try container.encodeIfPresent(securityNotesUrl, forKey: .securityNotesUrl)
        try container.encodeIfPresent(sources, forKey: .sources)
        try container.encodeIfPresent(rc, forKey: .rc)
    }
    
    var releasedDateType: Date? {
        if (releasedRaw != nil) {
            let dateFormatter = DateFormatter()
            let dateFormat = "yyyy-MM-dd"
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.date(from: releasedRaw!)
        } else {
            return nil
        }
    }
    
    func update(currentBytes: Int64, totalBytes: Int64) {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
    }
}

struct IpswFirmware: Codable {
    let identifier: String?
    let version: String?
    let buildid: String?
    let sha1sum: String?
    let md5sum: String?
    let filesize: UInt64?
    let url: String?
    let signed: Bool?
}

class FirmwareSources: ObservableObject, Codable {
    @Published private(set) var type: String
    @Published private(set) var deviceMap: [String]?
    @Published private(set) var links: [FirmwareLink]?
    @Published private(set) var size: Int64?
    @Published private(set) var hashes: FirmwareHashes?
    
    enum CodingKeys: String, CodingKey {
        case type, deviceMap, links, size, hashes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        deviceMap = try container.decodeIfPresent([String].self, forKey: .deviceMap)
        links = try container.decodeIfPresent([FirmwareLink].self, forKey: .links)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
        hashes = try container.decodeIfPresent(FirmwareHashes.self, forKey: .hashes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(deviceMap, forKey: .deviceMap)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(hashes, forKey: .hashes)
    }
}

class FirmwareLink: ObservableObject, Codable {
    @Published private(set) var url: String?
    @Published private(set) var preferred: Bool
    @Published private(set) var active: Bool
    
    enum CodingKeys: String, CodingKey {
        case url, preferred, active
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        preferred = try container.decode(Bool.self, forKey: .preferred)
        active = try container.decode(Bool.self, forKey: .active)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encode(preferred, forKey: .preferred)
        try container.encode(active, forKey: .active)
    }
}

class FirmwareHashes: ObservableObject, Codable {
    @Published private(set) var sha1: String?
    @Published private(set) var sha256: String?
    
    private enum CodingKeys: String, CodingKey {
        case sha1, sha256 = "sha2-256"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        sha256 = try container.decodeIfPresent(String.self, forKey: .sha256)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sha1, forKey: .sha1)
        try container.encodeIfPresent(sha256, forKey: .sha256)
    }
}

enum DeviceGroupType: String, Codable, CaseIterable {
    case iOSDevices = "iOS Devices"
    case macs = "Macs"
    case homeAndAccessories = "Home and Accessories"
    case audio = "Audio"
    case iPods = "iPods"
    case inputs = "Inputs"
}

extension Firmware {
    var fileURL: URL {
        URL.downloadsDirectory
            .appending(path: "\(key)")
            .appendingPathExtension("ipsw")
    }
}

struct DeviceImages: Codable {
    var id: String { key }
    let key: String
    let count: Int
    let dark: Bool
    let index: [DeviceImageIndex]
}

struct DeviceImageIndex: Codable {
    let id: IdType
    let dark: Bool
    
    var idText: String {
        switch id {
        case .int(let int): return int.description
        case .string(let string): return string
        }
    }
    
    enum IdType: Codable {
        case string(String)
        case int(Int)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else {
                throw DecodingError.typeMismatch(IdType.self,
                    DecodingError.Context(codingPath: decoder.codingPath,
                    debugDescription: "❌ Invalid type for IdType"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let string): try container.encode(string)
            case .int(let int): try container.encode(int)
            }
        }
    }
}
