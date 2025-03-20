//
//  PresentationKey.swift
//  PearDB
//
//  Created by Paras KCD on 20/3/25.
//

import SwiftUI

struct PresentationKey: EnvironmentKey {
    static let defaultValue: [Binding<Bool>] = []
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey.self] }
        set { self[PresentationKey.self] = newValue }
    }
}
