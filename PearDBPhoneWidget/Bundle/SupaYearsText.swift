//
//  SuperBroGN.swift
//  PearDBWatchWidgetExtension
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaYearsTextEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

struct SupaYearsTextTimeLineProvider: TimelineProvider {
    typealias Entry = SupaYearsTextEntry
    
    func placeholder(in context: Context) -> Entry {
        return SupaYearsTextEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SupaYearsTextEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SupaYearsTextEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SupaYearsTextWidgetView: View {
    
    let entry: SupaYearsTextEntry
    
    var body: some View {
        HStack {
            VStack {
                Text("Superbro")
                Text("2005-2024")
            }
            .widgetBackground(Color.clear)
        }
        
    }
}

struct SupaYearsTextWidget: Widget {
    let kind: String = "SupaYearsText"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaYearsTextTimeLineProvider()) { entry in
            SupaYearsTextWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Years Text")
        .description("SuperBro Living Years, Text only")
        .supportedFamilies([.accessoryRectangular])
    }
}
