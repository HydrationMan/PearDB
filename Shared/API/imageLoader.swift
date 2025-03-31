//
//  imageLoader.swift
//  PearDB
//
//  Created by Kane Parkinson on 04/02/2025.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    #if os(macOS)
    @State private var image: NSImage?
    #else
    @State private var image: UIImage?
    #endif
    @State private var loadingState: LoadingState = .loading
    
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

            // Handle image data
            #if os(macOS)
            guard let data = data, let img = NSImage(data: data) else {
                print("❌ No valid image data received for URL: \(url.absoluteString)")
                DispatchQueue.main.async {
                    self.loadingState = .failed
                }
                return
            }
            #else
            guard let data = data, let img = UIImage(data: data) else {
                print("❌ No valid image data received for URL: \(url.absoluteString)")
                DispatchQueue.main.async {
                    self.loadingState = .failed
                }
                return
            }
            #endif
            DispatchQueue.main.async {
                self.image = img
                self.loadingState = .success
            }
        }.resume()
    }
}
