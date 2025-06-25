//
//  LeftSupa.swift
//  PearDBWatchWidget
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct LeftSupaEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

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
        let entry = LeftSupaEntry(date: currentDate, providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct LeftSupaWidgetView: View {
    
    let entry: LeftSupaEntry
    
    private var isBirthdayToday: Bool {
        let today = Calendar.current.dateComponents([.day, .month], from: entry.date)
        return today.day == 8 && today.month == 9
    }
    
    var body: some View {
        Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupaLeft" : "NoBDaySupaLeft") ?? UIImage())
            .resizable()
            .frame(width: 42, height: 42)
            .widgetBackground(Color.clear)
        
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

