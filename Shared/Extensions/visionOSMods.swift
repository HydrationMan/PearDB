//
//  visionOSMods.swift
//  PearDB
//
//  Created by Paras KCD on 23/3/25.
//

import SwiftUI

struct VisionOSMods<Content> {
    let content: Content
}

extension View {
    var visionOSMods: VisionOSMods<Self> { VisionOSMods(content: self) }
}

extension VisionOSMods where Content: View {
    @ViewBuilder func padding3D(_ edgesStr: String = "all", _ length: CGFloat? = nil) -> some View {
        #if os(visionOS)
            var edges: Edge3D.Set {
                switch(edgesStr) {
                case "top": return .top
                case "leading": return .leading
                case "bottom": return .bottom
                case "depth": return .depth
                case "trailing": return .trailing
                case "back": return .back
                case "front": return .front
                case "horizontal": return .horizontal
                case "vertical": return .vertical
                default: return .all
                }
            }
            content.padding3D(edges, length)
        #else
            content
        #endif
    }
    
    @ViewBuilder func padding(_ length: CGFloat) -> some View {
        #if os(visionOS)
            content.padding(length)
        #else
            content
        #endif
    }
    
    @ViewBuilder func cornerRadius(_ radius: CGFloat, antialiased: Bool = true) -> some View {
        #if os(visionOS)
            content.cornerRadius(radius)
        #else
            content
        #endif
    }
    
    @ViewBuilder func frame(depth: CGFloat?) -> some View {
        #if os(visionOS)
            content.frame(depth: depth)
        #else
            content
        #endif
    }
}
