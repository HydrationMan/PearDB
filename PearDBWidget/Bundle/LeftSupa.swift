//
//  SwiftUIView.swift
//  PearDBWidgetExtension
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct LeftSupaEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

//var smallfamilies: [WidgetFamily] {
//#if os(watchOS)
//    return [.accessoryInline, .accessoryCircular, .accessoryRectangular]
//#else
//    if #available(iOS 16.0, *) {
//        return [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular]
//    } else {
//        return [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
//    }
//#endif
//}

struct LeftSupaTimeLineProvider: TimelineProvider {
    typealias Entry = LeftSupaEntry
    
    func placeholder(in context: Context) -> Entry {
        return LeftSupaEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = LeftSupaEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = LeftSupaEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct LeftSupaWidgetView: View {
    
    let entry: LeftSupaEntry
    
    var body: some View {
        Image("LeftSupa").resizable()
            .frame(width: 42, height: 42)
            .containerBackground(for: .widget) {
                Color.clear
            }
        
    }
}

struct LeftSupaWidget: Widget {
    let kind: String = "LeftSupa"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LeftSupaTimeLineProvider()) { entry in
            LeftSupaWidgetView(entry: entry)
        }
        .configurationDisplayName("Left Supa")
        .description("Left Facing Supa")
        .supportedFamilies([.accessoryCircular])
    }
}

