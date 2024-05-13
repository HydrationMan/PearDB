//
//  SettingsView.swift
//  PearDB
//
//  Created by Kane Parkinson on 12/05/2024.
//

import SwiftUI

struct SettingsView: View {
    let navigationTable = [
        [
        NavigationItem(name: "Display", description: "", menu: .displays),
        NavigationItem(name: "Languages", description: "", menu: .languages),
        ],
        [
        NavigationItem(name: "Licences", description: "", menu: .licences),
        NavigationItem(name: "Github Repository", description: "", menu: .githubrepository),
        NavigationItem(name: "Support via Ko-Fi", description: "", menu: .supportviakofi),
        ],
        [
        NavigationItem(name: "Clear Network Cache", description: "", menu: .clearnetworkcache),
        NavigationItem(name: "Reset Settings", description: "", menu: .resetsettings)
        ],
        ]
        
    let sectionTitles = ["General", "About", "Advanced"]
    @State private var SettingsSubView: String? = nil
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(0..<sectionTitles.count, id: \.self) { sectionIndex in
                        Section(header: Text(sectionTitles[sectionIndex]).foregroundLinearGradient(colors: [Color(hex: 0x79a4f2), Color(hex: 0xc9dcff)], startPoint: .leading, endPoint: .trailing)) {
                            ForEach(navigationTable[sectionIndex], id: \.self) { rowData in
                                NavigationLink(rowData.name, value: rowData)
                            }
                        }
                    }
                }
                .navigationTitle("Detail")
                

                .navigationDestination(for: NavigationItem.self, destination: { item in
                    switch item.menu {
                    case .displays:
                        Display()
                    case .languages:
                        Languages()
                    case .licences:
                        Licences()
                    case .githubrepository:
                        GithubRepository()
                    case .supportviakofi:
                        SupportViaKoFi()
                    case .clearnetworkcache:
                        ClearNetworkCache()
                    case .resetsettings:
                        ResetSettings()
                    }
                })
            }
        }
    }
}

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {

            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self

            )
        }
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct NavigationItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var menu: Menu
}


enum Menu: String {
    case displays
    case languages
    case licences
    case githubrepository
    case supportviakofi
    case clearnetworkcache
    case resetsettings
}

func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
    var gradientImage:UIImage?
    UIGraphicsBeginImageContext(gradientLayer.frame.size)
    if let context = UIGraphicsGetCurrentContext() {
        gradientLayer.render(in: context)
        gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
    }
    UIGraphicsEndImageContext()
    return gradientImage
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        var gradientColor = UIColor.label
        let blue = UIColor.systemCyan
        let purple = UIColor.systemRed
        
        let largeTitleFont = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        let longestTitle = "My Awesome App"
        let size = longestTitle.size(withAttributes: [.font : largeTitleFont])
        let gradient = CAGradientLayer()
        let bounds = CGRect(origin: navigationBar.bounds.origin, size: CGSize(width: size.width, height: navigationBar.bounds.height))
        gradient.frame = bounds
        gradient.colors = [blue.cgColor, purple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        if let image = getImageFrom(gradientLayer: gradient) {
            gradientColor = UIColor(patternImage: image)
        }
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        
        if let largeTitleDescriptor = largeTitleFont.fontDescriptor.withDesign(.rounded) {
            scrollEdgeAppearance.largeTitleTextAttributes = [.font : UIFont(descriptor: largeTitleDescriptor, size: 0), .foregroundColor : gradientColor]
        }
        
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
}
