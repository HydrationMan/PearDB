//
//  HardwareDetailView.swift
//  PearDB
//
//  Created by Kane Parkinson on 07/08/2024.
//

import SwiftUI
import Combine

struct HardwareDetailView: View {
    @ObservedObject var vm: EditHardwareViewModel
    let hardware: Hardware
    @State private var showEdit: Bool = false
    var body: some View {
        if showEdit {
            EditHardwareView(vm: vm, hardware: hardware)
        }
        VStack(alignment: .center) {
            AsyncCachedImage(
                url: URL(string: "https://img.appledb.dev/device@main/\(hardware.identifier)/0.avif"),
                failurePlaceholder: "xmark.octagon",
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                },
                placeholder: {
                    ProgressView() // A simple placeholder using a loading spinner
                        .frame(width: 200, height: 200)
                }
            )
        }
        List {
            Section("General") {
                
                LabeledContent {
                    Text(hardware.device)
                } label: {
                    Text("Device")
                }
                
                LabeledContent {
                    Text(hardware.identifier)
                } label: {
                    Text("Model")
                }
                
                LabeledContent {
                    Text(hardware.version)
                } label: {
                    Text("Version")
                }
                
                LabeledContent {
                    Text(hardware.build)
                        .foregroundStyle(colorBasedOnHardware())
                } label: {
                    Text("Build")
                }
                
                LabeledContent {
                    Text(hardware.chip)
                } label: {
                    Text("Chip")
                }
            }
            
            Section("Notes") {
                Text(hardware.note)
            }
        }
        .navigationTitle("Detail")
    }
    private func colorBasedOnHardware() -> Color {
        if hardware.buildUpdateLatest {
            return .green // Color for the latest update
        } else if hardware.buildUpdateAvailable {
            return .yellow // Color for update available
        } else if hardware.buildFinal {
            return .blue // Color for final builds
        } else if hardware.buildBeta {
            return .purple // Color for beta builds
        } else {
            return .gray // Default color if none of the conditions are met
        }
    }
}

//#Preview {
//    HardwareDetailView()
//}
@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    // Input dependencies
    var url: URL?
    var failurePlaceholder: String
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    // Downloaded image
    @State var image: UIImage? = nil
    
    init(
        url: URL?,
        failurePlaceholder: String = "exclamationmark.triangle",
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.failurePlaceholder = failurePlaceholder
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                    }
            }
        }
    }
    
    // Downloads if the image is not cached already
    // Otherwise returns from the cache
    private func downloadPhoto() async -> UIImage? {
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [.white])
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let imageConfig = colorsConfig.applying(sizeConfig)
        let image = UIImage(systemName: failurePlaceholder, withConfiguration: imageConfig)?
            .withRenderingMode(.alwaysOriginal)
        do {
            guard let url else { return nil }
            
            // Check if the image is cached already
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                return UIImage(data: cachedResponse.data) ?? image
            } else {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Save returned image data into the cache
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                
                return UIImage(data: data) ?? image
            }
        } catch {
            print("Error downloading: \(error)")
            return image
        }
    }
}
