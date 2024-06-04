//
//  NavigationLinkInator.swift
//  PearDB
//
//  Created by Kane Parkinson on 13/05/2024.
//

import SwiftUI

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
