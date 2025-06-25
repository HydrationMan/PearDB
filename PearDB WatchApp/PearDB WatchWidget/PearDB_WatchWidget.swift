//
//  PearDB_WatchWidget.swift
//  PearDB WatchWidget
//
//  Created by Kane Parkinson on 24/06/2025.
//

import WidgetKit
import SwiftUI

@main
struct PearDBWatchWidgetBundle: WidgetBundle {
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

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(watchOSApplicationExtension 10.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return backgroundView
        }
    }
}

public struct Backport<Content> {
    public let content: Content

    public init(_ content: Content) {
        self.content = content
    }
}

extension View {
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {
    @ViewBuilder func widgetCurvesContent() -> some View {
        if #available(watchOS 10.0, iOSApplicationExtension 17.0, iOS 17.0, macOSApplicationExtension 14.0, *) {
            content.widgetCurvesContent()

        } else {
            content
        }
    }
}
