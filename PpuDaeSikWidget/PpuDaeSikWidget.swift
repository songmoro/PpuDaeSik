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
        checkDatabase { isUpdate in
            // let (code, type) = get~
            let code = getCode(for: configuration)
            let type = getType(for: configuration)
            let currentDate = Date()
            let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

            if isUpdate {
                queryDatabase(true, code, type) {
                    let entry = SimpleEntry(configuration: configuration, date: currentDate, emoji: $0)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                    
                    completion(timeline)
                }
            }
            else {
                queryDatabase(false, code, type) {
                    let entry = SimpleEntry(configuration: configuration, date: currentDate, emoji: $0)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                    
                    completion(timeline)
                }
            }
        }
    }
    
    func getCode(for configuration: ConfigurationIntent) -> String {
        switch configuration.RestaurantEnum {
        case .d001:
            Domitory.진리관.code()
        case .d002:
            Domitory.웅비관.code()
        case .d003:
            Domitory.자유관.code()
        case .d004:
            Domitory.비마관.code()
        case .d005:
            Domitory.행림관.code()
        case .g001:
            Restaurant.금정회관교직원식당.code()
        case .g002:
            Restaurant.금정회관학생식당.code()
        case .h001:
            Restaurant.학생회관학생식당.code()
        case .m001:
            Restaurant.학생회관밀양교직원식당.code()
        case .m002:
            Restaurant.학생회관밀양학생식당.code()
        case .s001:
            Restaurant.샛벌회관식당.code()
        case .y001:
            Restaurant.편의동2층양산식당.code()
        case .unknown:
            ""
        }
    }
    
    func getType(for configuration: ConfigurationIntent) -> QueryType {
        switch configuration.RestaurantEnum {
        case .d001, .d002, .d003, .d004, .d005:
            QueryType.domitory
        case .g001, .g002, .h001, .m001, .m002, .s001, .y001:
            QueryType.restaurant
        case .unknown:
            QueryType.restaurant
        }
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
        ZStack(alignment: .topLeading) {
            Color.gray100.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("금정회관")
                        .bold()
                    
                    Text("조식")
                        .foregroundColor(.black40)
                }
                .font(.subheadline)
                .padding(.bottom, 4)
                
                HStack {
                    Text(entry.emoji)
                        .font(.caption)
                }
            }
            .foregroundColor(.black100)
        }
    }
}

struct PpuDaeSikWidget: Widget {
    let kind: String = "PpuDaeSikWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PpuDaeSikWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.gray100.ignoresSafeArea()
                }
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
