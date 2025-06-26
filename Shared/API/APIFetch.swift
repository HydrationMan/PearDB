//
//  apiFetch.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import Foundation

class AppleDBService: ObservableObject {
    @Published var devices: [Device] = []
    @Published var deviceNames: [String] = []
    
    private let baseURL = "https://api.appledb.dev/device"
    
    func fetchDeviceNames() {
        guard let url = URL(string: "\(baseURL)/index.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    if let decoded = try? JSONDecoder().decode([String].self, from: data) {
                        self.deviceNames = decoded
                    }
                }
            }
        }.resume()
    }
    
    func fetchDevices() {
        guard let url = URL(string: "\(baseURL)/main.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    if let decoded = try? JSONDecoder().decode([Device].self, from: data) {
                        self.devices = decoded
                    }
                }
            }
        }.resume()
    }
    
    func fetchDeviceDetails(for key: String, completion: @escaping (Device?) -> Void) {
        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? key
        let urlString = "https://api.appledb.dev/device/\(encodedKey).json"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network Error: \(error.localizedDescription)")
                print("   ↳ URL: \(urlString)")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("❌ HTTP Error: \(httpResponse.statusCode) for URL: \(urlString)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ No data received for URL: \(urlString)")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedDevice = try decoder.decode(Device.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedDevice)
                }
            } catch let DecodingError.typeMismatch(type, context) {
                print("❌ JSON Decoding Error: Type mismatch (\(type))")
                print("   ↳ Coding Path: \(context.codingPath)")
                print("   ↳ Debug Description: \(context.debugDescription)")
                print("   ↳ URL: \(urlString)")
                completion(nil)
            } catch {
                print("❌ General JSON Decoding Error: \(error)")
                print("   ↳ URL: \(urlString)")
                completion(nil)
            }
        }.resume()
    }
}
