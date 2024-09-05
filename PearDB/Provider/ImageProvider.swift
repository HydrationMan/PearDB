//
//  ImageProvider.swift
//  PearDB
//
//  Created by Kane Parkinson on 29/08/2024.
//

import SwiftUI
import Combine
import Foundation

struct Device: Decodable {
    var name: String
    var soc: String
    var arch: String
    var type: String
    var released: [String]
    var supportedArchitectures: [String]
    var relatedDevices: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        self.arch = try container.decodeIfPresent(String.self, forKey: .arch) ?? "Unknown"
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "Unknown"
        
        if let releasedArray = try? container.decode([String].self, forKey: .released) {
            self.released = releasedArray
        } else if let releasedString = try? container.decode(String.self, forKey: .released) {
            self.released = [releasedString]
        } else {
            self.released = ["Unknown"]
        }
        
        self.supportedArchitectures = try container.decodeIfPresent([String].self, forKey: .supportedArchitectures) ?? []
        self.relatedDevices = try container.decodeIfPresent([String].self, forKey: .relatedDevices) ?? []
        
        if let socArray = try? container.decode([String].self, forKey: .soc) {
            self.soc = socArray.joined(separator: ", ")
        } else if let socString = try? container.decode(String.self, forKey: .soc) {
            self.soc = socString
        } else {
            self.soc = "Unknown"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name, soc, arch, type, released, supportedArchitectures, relatedDevices
    }
}
class firmwareModel: ObservableObject {
    @Published var selectedFirmware: FirmwareEntry?
    @Published var buildRC: Bool = false
    @Published var buildBeta: Bool = false
    @Published var buildInternal: Bool = false
    @Published var version: String = ""
    @Published var build: String = ""
    @Published var osStr: String = ""
}

class appleDBPoll: ObservableObject {
    @Published var name: String = ""
    @Published var soc: String = ""
    @Published var arch: String = ""
    @Published var type: String = ""
    @Published var released: String = ""
    @Published var identifier: String = ""
    @Published var response: URLResponse?
    @Published var error: Bool = false
    private var cancellables = Set<AnyCancellable>()

    func simplefetch() {
        guard let url = URL(string: "https://api.appledb.dev/device/\(identifier).json") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(Device.self, from: data)
                    DispatchQueue.main.async {
                        self.released = decodedData.released.joined(separator: ", ")
                        self.name = decodedData.name
                        self.soc = decodedData.soc
                        self.arch = decodedData.arch
                        self.type = decodedData.type
                        print("Supported Architectures: \(decodedData.supportedArchitectures)")
                        print("Related Devices: \(decodedData.relatedDevices)")
                        print(decodedData.released)
                        self.response = response
                        self.error = false
                    }
                } catch {
                    print("simplefetch; Error decoding JSON: '\(error)'")
                    print("didFailDecodingJSON Hit")
                    print(url)
                    DispatchQueue.main.async {
                        self.error = true
                    }
                }
            } else if let error = error {
                print("simplefetch; error fetching JSON: \(error)")
                print("didFailFetchingJSON Hit")
                print(url)
                DispatchQueue.main.async {
                    self.error = true
                }
            }
        }.resume()
    }
}
