//
//  PpuDaeSikWidget.swift
//  PpuDaeSikWidget
//
//  Created by 송재훈 on 5/3/24.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent(), date: Date(), emoji: "😀")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(configuration: configuration, date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        checkDatabase()
//        checkDatabase { str in
            let currentDate = Date()
            let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = SimpleEntry(configuration: configuration, date: currentDate, emoji: "")

            let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
            
            completion(timeline)
//        }
    }
}

struct SimpleEntry: TimelineEntry {
    let configuration: ConfigurationIntent
    let date: Date
    let emoji: String
}

struct PpuDaeSikWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct PpuDaeSikWidget: Widget {
    let kind: String = "PpuDaeSikWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PpuDaeSikWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("뿌대식")
        .description("메뉴를 좀 더 간편하게 확인해보세요!")
    }
}

#Preview(as: .systemSmall) {
    PpuDaeSikWidget()
} timeline: {
    SimpleEntry(configuration: ConfigurationIntent(), date: .now, emoji: "😀")
    SimpleEntry(configuration: ConfigurationIntent(), date: .now, emoji: "🤩")
}
