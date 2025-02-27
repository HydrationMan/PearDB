//
//  BDaySupaLeft.swift
//  PearDBPhoneWidget
//
//  Created by Kane Parkinson on 15/05/2024.
//

import SwiftUI
import WidgetKit
import AppIntents

struct BDaySupaFlipEntry: TimelineEntry {
    let date: Date
    let isRightFacing: Bool
}

struct BDaySupaFlipTimelineProvider: AppIntentTimelineProvider {
    typealias Entry = BDaySupaFlipEntry
    typealias Intent = FlipImageIntent
    
    func placeholder(in context: Context) -> Entry {
        BDaySupaFlipEntry(date: Date(), isRightFacing: true)
    }

    func snapshot(for configuration: FlipImageIntent, in context: Context) async -> Entry {
        BDaySupaFlipEntry(date: Date(), isRightFacing: configuration.orientation == .right)
    }

    func timeline(for configuration: FlipImageIntent, in context: Context) async -> Timeline<Entry> {
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? currentDate
        
        let entry = BDaySupaFlipEntry(date: currentDate, isRightFacing: configuration.orientation == .right)
        return Timeline(entries: [entry], policy: .after(nextUpdateDate))
    }
}

struct BDaySupaFlipWidgetView: View {
    let entry: BDaySupaFlipEntry
    
    private var isBirthdayToday: Bool {
        let today = Calendar.current.dateComponents([.day, .month], from: entry.date)
        return today.day == 8 && today.month == 9
    }
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: isBirthdayToday ? "BDaySupa" : "NoBDaySupa") ?? UIImage())
                .resizable()
                .frame(width: 42, height: 42)
                .scaleEffect(x: entry.isRightFacing ? 1 : -1, y: 1) // Flip image horizontally
                .widgetAccentable()
            
            Text("Superbro")
                .widgetAccentable()
            Text("2005-2024")
                .widgetAccentable()
            
            if isBirthdayToday {
                Text("Happy Birthday Bro")
                    .foregroundColor(.gray)
                    .widgetAccentable()
                    .font(.system(size: 10))
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
        .padding()
    }
}

struct BDaySupaFlipWidget: Widget {
    let kind: String = "BDaySupaFlip"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: FlipImageIntent.self,
            provider: BDaySupaFlipTimelineProvider()
        ) { entry in
            BDaySupaFlipWidgetView(entry: entry)
        }
        .configurationDisplayName("Superbro Small")
        .description("Small Superbro widget, image orientation configurable.")
        .supportedFamilies([.systemSmall])
    }
}
