//
//  imageLoader.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

#if os(macOS)
    typealias PlatformImage = NSImage
#else
    typealias PlatformImage = UIImage
#endif

struct AsyncImageView: View {
    let url: String
    let key: String
    
    @State private var image: PlatformImage?
    @State private var loadingState: LoadingState = .loading
    
    private let localDirectory: URL?
    
    init(url: String, key: String) {
        self.url = url
        self.key = key
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.localDirectory = nil
            return
        }
        self.localDirectory = documentsDirectory.appendingPathComponent("ImageCache")
        self.createDirectoryIfNeeded()
    }
    
    enum LoadingState {
        case loading, success, failed
    }
    
    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                ProgressView()
            case .success:
                if let image = image {
                    #if os(macOS)
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                    #else
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    #endif
                    
                }
            case .failed:
                Image(.sad)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        guard let url = URL(string: encodedUrlString) else {
            print("❌ Invalid Image URL: \(encodedUrlString)")
            loadingState = .failed
            return
        }
        
        print("🌍 Fetching Image: \(url.absoluteString)")
        
        guard let img = self.getSavedImage(fileName: key + ".png") else {
            print("❌ Could not load from Local: \(key + ".png")")
            URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle network error
                if let error = error {
                    print("❌ Image Fetch Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.loadingState = .failed
                    }
                    return
                }

                // Handle HTTP response error
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 404 {
                        print("❌ Image not found (404) for URL: \(url.absoluteString)")
                    } else if httpResponse.statusCode != 200 {
                        print("❌ HTTP Error: \(httpResponse.statusCode) for Image URL: \(url.absoluteString)")
                    }
                    
                    if httpResponse.statusCode != 200 && httpResponse.statusCode != 404 {
                        DispatchQueue.main.async {
                            self.loadingState = .failed
                        }
                    }
                }
                guard let data = data, let img = PlatformImage(data: data) else {
                    print("❌ No valid image data received for URL: \(url.absoluteString)")
                    DispatchQueue.main.async {
                        self.loadingState = .failed
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.saveImage(image: img)
                    self.image = img
                    self.loadingState = .success
                }
            }.resume()
            
            return
        }
        
        self.image = img
        self.loadingState = .success
    }
    
    func saveImage(image: PlatformImage) {
        let fileName = key + ".png"
        guard let fileURL = self.localDirectory?.appendingPathComponent(fileName) else { return }
        guard let data = image.pngData() else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getSavedImage(fileName: String) -> PlatformImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent("ImageCache").appendingPathComponent(fileName)
            let image = PlatformImage(contentsOfFile: imageUrl.path)
            return image
     
        }
        
        return nil
    }
    
    private func createDirectoryIfNeeded() {
        let fileManager = FileManager.default
        guard let fileURL = self.localDirectory else { return }
        if !fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("❌ Error creating ImageCache directory: \(error.localizedDescription)")
            }
        }
    }
}
