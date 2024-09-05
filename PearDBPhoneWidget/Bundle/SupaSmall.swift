//
//  PearDBPhoneWidget.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 12/06/2024.
//

import SwiftUI
import WidgetKit

struct SmallSupaEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct SmallSupaTimeLineProvider: TimelineProvider {
    typealias Entry = SmallSupaEntry
    
    func placeholder(in context: Context) -> Entry {
        return SmallSupaEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SmallSupaEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SmallSupaEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SmallSupaWidgetView: View {
    
    let entry: SmallSupaEntry
    
    var body: some View {
        Image("RightSupa").resizable()
            .frame(width: 42, height: 42)
            .widgetBackground(Color.clear)
        
    }
}

struct SmallSupaWidget: Widget {
    let kind: String = "SmallSupa"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmallSupaTimeLineProvider()) { entry in
            SmallSupaWidgetView(entry: entry)
        }
        .configurationDisplayName("Left Supa")
        .description("Left Facing Supa")
        .supportedFamilies([.systemSmall])
    }
}

