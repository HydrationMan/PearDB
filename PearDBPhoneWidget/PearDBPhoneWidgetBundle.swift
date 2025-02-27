//
//  PearDBPhoneWidgetBundle.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 12/06/2024.
//

import WidgetKit
import SwiftUI
import AppIntents

@main
struct PearDBPhoneWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        SupaWidget()
        SupaYearsWidget()
        BDaySupaFlipWidget()
    }
}

enum ImageOrientation: String, AppEnum {
    case left = "Left"
    case right = "Right"
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Image Orientation")
    
    static var caseDisplayRepresentations: [ImageOrientation: DisplayRepresentation] = [
        .left: DisplayRepresentation(title: "Left Facing"),
        .right: DisplayRepresentation(title: "Right Facing")
    ]
}

struct FlipImageIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Image Orientation"
    static var description = IntentDescription("Choose whether the image should face left or right.")
    
    @Parameter(title: "Orientation", default: .right)
    var orientation: ImageOrientation?
}
