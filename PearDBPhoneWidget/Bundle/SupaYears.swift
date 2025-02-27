//
//  SupaYears.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit
import AppIntents

struct SupaYearsEntry: TimelineEntry {
    let date: Date
    let isRightFacing: Bool
}

struct SupaYearsTimeLineProvider: AppIntentTimelineProvider {
    typealias Entry = SupaYearsEntry
    typealias Intent = FlipImageIntent
    
    func placeholder(in context: Context) -> Entry {
        SupaYearsEntry(date: Date(), isRightFacing: true)
    }

    func snapshot(for configuration: FlipImageIntent, in context: Context) async -> Entry {
        SupaYearsEntry(date: Date(), isRightFacing: configuration.orientation == .right)
    }

    func timeline(for configuration: FlipImageIntent, in context: Context) async -> Timeline<Entry> {
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        
        let entry = SupaYearsEntry(date: currentDate, isRightFacing: configuration.orientation == .right)
        return Timeline(entries: [entry], policy: .after(nextUpdateDate))
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
            Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupa" : "NoBDaySupa") ?? UIImage())
                .resizable()
                .frame(width: 42, height: 42)
                .scaleEffect(x: entry.isRightFacing ? 1 : -1, y: 1) // Flip image horizontally
                .widgetAccentable()
            VStack {
                Text("Superbro")
                Text("2005-2024")
                if isBirthdayToday {
                    Text("Happy Birthday Bro")
                        .foregroundColor(.gray)
                        .widgetAccentable()
                        .font(.system(size: 10))
                }
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct SupaYearsWidget: Widget {
    let kind: String = "SupaYears"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: FlipImageIntent.self,
            provider: SupaYearsTimeLineProvider()
        ) { entry in
            SupaYearsWidgetView(entry: entry)
        }
        .configurationDisplayName("Superbro smaller")
        .description("Smaller Superbro widget, image orientation configurable.")
        .supportedFamilies([.accessoryRectangular])
    }
}
