//
//  UINavigationControllerInator.swift
//  PearDB
//
//  Created by [Redacted] on 14/05/2024.
//

import SwiftUI

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
