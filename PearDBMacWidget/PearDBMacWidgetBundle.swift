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
        return containerBackground(for: .widget) {
            backgroundView
        }
    }
}
