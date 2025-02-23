//
//  PearDBMacWidgetBundle.swift
//  PearDBMacWidget
//
//  Created by Kane Parkinson on 22/02/2025.
//

import WidgetKit
import SwiftUI

@main
struct PearDBPhoneWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
//        if #available(iOSApplicationExtension 16.1, *) {
//            LeftSupaWidget()
//            RightSupaWidget()
//            SupaYearsWidget()
//        }
//        BDaySupaLeftWidget()
        BDaySupaFlipWidget()
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
