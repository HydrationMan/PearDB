//
//  SupaInline.swift
//  PearDBWatchWidget
//
//  Created by Kane Parkinson on 16/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaInlineEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct SupaInlineTimeLineProvider: TimelineProvider {
    typealias Entry = SupaInlineEntry
    
    func placeholder(in context: Context) -> Entry {
        return SupaInlineEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SupaInlineEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SupaInlineEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SupaInlineWidgetView: View {
    
    let entry: SupaInlineEntry
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "SmolSupaRight") ?? UIImage()).resizable()
            Text("2005-2024")
                .widgetLabel("SuperBro: 2005 Through 2024")
                .backport.widgetCurvesContent()
                .unredacted()
        }
    }
}

struct SupaInlineWidget: Widget {
    let kind: String = "SupaInline"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaInlineTimeLineProvider()) { entry in
            SupaInlineWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Inline")
        .description("Supa do be Inline")
        .supportedFamilies([.accessoryInline])
    }
}
