//
//  SupaCornerLeft.swift
//  PearDBWidgetExtension
//
//  Created by Kane Parkinson on 16/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaCornerLeftEntry: TimelineEntry {
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

struct SupaCornerLeftTimeLineProvider: TimelineProvider {
    typealias Entry = SupaCornerLeftEntry
    
    func placeholder(in context: Context) -> Entry {
        return SupaCornerLeftEntry(date: Date(), providerInfo: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = SupaCornerLeftEntry(date: Date(), providerInfo: "snapshot")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SupaCornerLeftEntry(date: Date(), providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SupaCornerLeftWidgetView: View {
    
    let entry: SupaCornerLeftEntry
    
    var body: some View {
        Text(Image.supaCornerLeft)
            .font(.system(size: 10))
            .widgetCurvesContent()
            .widgetLabel("Supa!")
            .containerBackground(for: .widget) {
                Color.clear
        }
    }
}

struct SupaCornerLeftWidget: Widget {
    let kind: String = "SupaCornerLeft"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaCornerLeftTimeLineProvider()) { entry in
            SupaCornerLeftWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Corner")
        .description("Supa in da Corner")
        .supportedFamilies([.accessoryCorner])
    }
}

extension Image {
    static var supaCornerLeft: Image {
        Image("SmolSupaLeft")
    }
}
