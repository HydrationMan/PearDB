//
//  PearDBPhoneWidget.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 12/06/2024.
//

import SwiftUI
import WidgetKit

struct SmolSupaEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct SmolSupaTimeLineProvider: TimelineProvider {
    typealias Entry = SmolSupaEntry
    
    func placeholder(in context: Context) -> Entry {
        return SmolSupaEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SmolSupaEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SmolSupaEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SmolSupaWidgetView: View {
    
    let entry: SmolSupaEntry
    
    var body: some View {
        Image("SmolSupa").resizable()
            .frame(width: 42, height: 42)
            .widgetBackground(Color.clear)
        
    }
}

struct SmolSupaWidget: Widget {
    let kind: String = "SmolSupa"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmolSupaTimeLineProvider()) { entry in
            SmolSupaWidgetView(entry: entry)
        }
        .configurationDisplayName("Smol Supa")
        .description("Small Supa Widget")
        .supportedFamilies([.systemSmall])
    }
}

