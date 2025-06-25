//
//  SupaCornerLeft.swift
//  PearDBWatchWidget
//
//  Created by Kane Parkinson on 16/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaCornerLeftEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

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
            .backport.widgetCurvesContent()
            .widgetLabel("Supa!")
            .widgetBackground(Color.clear)
    }
}

struct SupaCornerLeftWidget: Widget {
    let kind: String = "SupaCornerLeft"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SupaCornerLeftTimeLineProvider()) { entry in
            SupaCornerLeftWidgetView(entry: entry)
        }
        .configurationDisplayName("Supa Corner Left")
        .description("Supa Corner - Left Facing")
        .supportedFamilies([.accessoryCorner])
    }
}

extension Image {
    static var supaCornerLeft: Image {
        Image("SmolSupaLeft")
    }
}
