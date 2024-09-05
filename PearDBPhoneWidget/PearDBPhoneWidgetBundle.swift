//
//  PearDBPhoneWidgetBundle.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 12/06/2024.
//

import WidgetKit
import SwiftUI

@main
struct PearDBPhoneWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        LeftSupaWidget()
        RightSupaWidget()
        SupaYearsWidget()
        SupaYearsTextWidget()
//        SmallSupaWidget()
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return backgroundView
        }
    }
}
