//
//  SupaMedium.swift
//  PearDBWatchWidgetExtension
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct RightSupaEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct RightSupaTimeLineProvider: TimelineProvider {
    typealias Entry = RightSupaEntry
    
    func placeholder(in context: Context) -> Entry {
        return RightSupaEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = RightSupaEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = RightSupaEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct RightSupaWidgetView: View {
    
    let entry: RightSupaEntry
    
    var body: some View {
        Image("RightSupa").resizable()
            .frame(width: 42, height: 42)
            .widgetBackground(Color.clear)
        
    }
}

struct RightSupaWidget: Widget {
    let kind: String = "RightSupa"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RightSupaTimeLineProvider()) { entry in
            RightSupaWidgetView(entry: entry)
        }
        .configurationDisplayName("Right Supa")
        .description("Right Facing Supa")
        .supportedFamilies([.accessoryCircular])
    }
}
