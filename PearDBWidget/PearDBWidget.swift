//
//  PearDBWidget.swift
//  PearDBWidget
//
//  Created by Kane Parkinson on 15/05/2024.
//

import WidgetKit
import SwiftUI

@main
struct PearDBWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        LeftSupaWidget()
        RightSupaWidget()
        SupaInlineWidget()
        SupaYearsWidget()
        SupaCornerLeftWidget()
        SupaCornerRightWidget()
    }
}
