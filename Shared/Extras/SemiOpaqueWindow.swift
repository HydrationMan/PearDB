//
//  SemiOpaqueWindow.swift
//  PearDB
//
//  Created by Paras KCD on 16/2/25.
//

import SwiftUI

#if os(macOS)
extension View {
    public static func semiOpaqueWindow() -> some View {
        VisualEffect().ignoresSafeArea()
    }
}

struct VisualEffect : NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.state = .active
        return view
    }
    func updateNSView(_ view: NSView, context: Context) { }
}
#endif
