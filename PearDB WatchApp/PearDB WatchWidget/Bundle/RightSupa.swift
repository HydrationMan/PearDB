//
//  RightSupa.swift
//  PearDBWatchWidget
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
        let currentDate = Date()
        var nextUpdateDate: Date
        
        // Determine the next update time
        let today = Calendar.current.dateComponents([.day, .month], from: currentDate)
        
        if today.day == 7 && today.month == 9 {
            // On September 7th, update hourly
            nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        } else {
            // Set the next update for midnight
            nextUpdateDate = Calendar.current.startOfDay(for: currentDate).addingTimeInterval(86400) // Midnight of the next day
        }
        
        // Create the timeline entry
        let entry = RightSupaEntry(date: currentDate, providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct RightSupaWidgetView: View {
    
    let entry: RightSupaEntry
    
    private var isBirthdayToday: Bool {
        let today = Calendar.current.dateComponents([.day, .month], from: entry.date)
        return today.day == 8 && today.month == 9
    }
    
    var body: some View {
        Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupaRight" : "NoBDaySupaRight") ?? UIImage())
            .resizable()
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
