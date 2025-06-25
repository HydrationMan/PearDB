//
//  SupaYears.swift
//  PearDBWatchWidget
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit

struct SupaYearsEntry: TimelineEntry {
    let date: Date
    let providerInfo: String
}

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
        let entry = SupaYearsEntry(date: currentDate, providerInfo: "timeline")
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct SupaYearsWidgetView: View {
    
    let entry: SupaYearsEntry
    
    private var isBirthdayToday: Bool {
        let today = Calendar.current.dateComponents([.day, .month], from: entry.date)
        return today.day == 8 && today.month == 9
    }
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupaRight" : "NoBDaySupaRight") ?? UIImage())
                .resizable()
                .frame(width: 42, height: 42)
                .widgetBackground(Color.clear)
            VStack {
                Text("Superbro")
                Text("2005-2024")
                if isBirthdayToday {
                    Text("Happy Birthday Bro")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
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
