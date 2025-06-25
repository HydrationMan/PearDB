//
//  LeftSupa.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 12/06/2024.
//

import SwiftUI
import WidgetKit

struct SupaEntry: TimelineEntry {
    let date: Date
    let isRightFacing: Bool
}

struct SupaTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = SupaEntry
    typealias Intent = FlipImageIntent
    
    func placeholder(in context: Context) -> Entry {
        SupaEntry(date: Date(), isRightFacing: true)
    }

    func snapshot(for configuration: FlipImageIntent, in context: Context) async -> Entry {
        SupaEntry(date: Date(), isRightFacing: configuration.orientation == .right)
    }

    func timeline(for configuration: FlipImageIntent, in context: Context) async -> Timeline<Entry> {
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        
        let entry = SupaEntry(date: currentDate, isRightFacing: configuration.orientation == .right)
        return Timeline(entries: [entry], policy: .after(nextUpdateDate))
    }
}

struct SupaWidgetView: View {
    
    let entry: SupaEntry
    
    private var isBirthdayToday: Bool {
        let today = Calendar.current.dateComponents([.day, .month], from: entry.date)
        return today.day == 8 && today.month == 9
    }
    
    var body: some View {
        #if os(iOS)
        Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupa" : "NoBDaySupa") ?? UIImage())
            .resizable()
            .frame(width: 42, height: 42)
            .scaleEffect(x: entry.isRightFacing ? 1 : -1, y: 1) // Flip image horizontally
            .widgetAccentable()
            .containerBackground(for: .widget) {
                Color.clear
            }
        #else
        Image(nsImage: NSImage(named: isBirthdayToday ? "BDaySupa" : "NoBDaySupa") ?? NSImage())
            .resizable()
            .frame(width: 42, height: 42)
            .scaleEffect(x: entry.isRightFacing ? 1 : -1, y: 1) // Flip image horizontally
            .widgetAccentable()
            .containerBackground(for: .widget) {
                Color.clear
            }
        #endif
        
    }
}

struct SupaWidget: Widget {
    let kind: String = "Supa"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: FlipImageIntent.self,
            provider: SupaTimelineProvider()
        ) { entry in
            SupaWidgetView(entry: entry)
        }
        .configurationDisplayName("Superbro smallest")
        .description("Smallest Superbro widget, image orientation configurable.")
        #if os(iOS)
        .supportedFamilies([.accessoryCircular])
        #else
        .supportedFamilies([.systemSmall])
        #endif
    }
}

