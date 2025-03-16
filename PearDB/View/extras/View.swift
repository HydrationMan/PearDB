//
//  View.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
