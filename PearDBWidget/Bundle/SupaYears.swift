//
//  SuperBroGN.swift
//  PearDBWidgetExtension
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaYearsEntry: TimelineEntry {
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

struct SupaYearsTimeLineProvider: TimelineProvider {
    typealias Entry = SupaYearsEntry
    
    func placeholder(in context: Context) -> Entry {
        return SupaYearsEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SupaYearsEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SupaYearsEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SupaYearsWidgetView: View {
    
    let entry: SupaYearsEntry
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "RightSupa") ?? UIImage()).resizable()
                .frame(width: 42, height: 42)
                .containerBackground(for: .widget) {
                    Color.clear
                }
            VStack {
                Text("Superbro")
                Text("2005-2024")
            }
        }
        
    }
}

struct SupaYearsWidget: Widget {
    let kind: String = "SupaYears"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaYearsTimeLineProvider()) { entry in
            SupaYearsWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Years")
        .description("SuperBro Living Years")
        .supportedFamilies([.accessoryRectangular])
    }
}
