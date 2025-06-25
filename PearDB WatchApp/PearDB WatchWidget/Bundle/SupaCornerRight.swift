//
//  SupaCornerRight.swift
//  PearDBWatchWidget
//
//  Created by Kane Parkinson on 16/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaCornerRightEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct SupaCornerRightTimeLineProvider: TimelineProvider {
    typealias Entry = SupaCornerRightEntry
    
    func placeholder(in context: Context) -> Entry {
        return SupaCornerRightEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SupaCornerRightEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SupaCornerRightEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SupaCornerRightWidgetView: View {
    
    let entry: SupaCornerRightEntry
    
    var body: some View {
        Text(Image.supaCornerRight)
            .font(.system(size: 10))
            .backport.widgetCurvesContent()
            .widgetLabel("Supa!")
            .widgetBackground(Color.clear)
    }
}

struct SupaCornerRightWidget: Widget {
    let kind: String = "SupaCornerRight"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaCornerRightTimeLineProvider()) { entry in
            SupaCornerRightWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Corner Right")
        .description("Supa Corner - Right Face")
        .supportedFamilies([.accessoryCorner])
    }
}

extension Image {
    static var supaCornerRight: Image {
        Image("SmolSupaRight")
    }
}
