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
        SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        guard let cafeteria = getCafeteria(for: configuration),
              let category = getCategory(for: configuration)
        else { return }
        let currentDate = Date()
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        checkStatus { queryType in
            queryDatabase(queryType, cafeteria, category: category) {
                let entry = SimpleEntry(configuration: configuration, date: currentDate, name: $0[0], category: $0[1], meal: $0[2])
                
                let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                
                completion(timeline)
            }
        }
    }
    
    func getCafeteria(for configuration: ConfigurationIntent) -> Cafeteria? {
        switch configuration.RestaurantEnum {
        case .d001: .진리관
        case .d002: .웅비관
        case .d003: .자유관
        case .d004: .비마관
        case .d005: .행림관
        case .g001: .금정회관교직원식당
        case .g002: .금정회관학생식당
        case .h001: .학생회관학생식당
        case .m001: .학생회관밀양교직원식당
        case .m002: .학생회관밀양학생식당
        case .s001: .샛벌회관식당
        case .y001: .편의동2층양산식당
        case .unknown: nil
        }
    }
    
    func getCategory(for configuration: ConfigurationIntent) -> String? {
        let hour = Calendar.current.component(.hour, from: Date())
        
        return switch configuration.RestaurantEnum {
        case .d001, .d002, .d003, .d004, .d005:
            switch hour {
            case 20...23:
                "01"
            case 0...8:
                "02"
            case 9...13:
                "03"
            case 14...19:
                "04"
            default:
                nil
            }
        case .g002, .y001:
            switch hour {
            case 20...23:
                "B"
            case 0...8:
                "B"
            case 9...13:
                "L"
            case 14...19:
                "D"
            default:
                nil
            }
        case .g001, .h001, .s001, .m001, .m002:
            switch hour {
            case 0...14:
                "L"
            case 15...19:
                "D"
            case 20...23:
                "L"
            default:
                nil
            }
        case .unknown:
            nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let configuration: ConfigurationIntent
    let date: Date
    let name: String
    let category: String
    let meal: String
}

struct PpuDaeSikWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.gray100.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(entry.name)")
                        .bold()
                    
                    Text("\(entry.category)")
                        .foregroundColor(.black40)
                }
                .font(.footnote)
                .padding(.bottom, 4)
                
                HStack {
                    Text(entry.meal)
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
        .supportedFamilies([.systemSmall])
    }
}

struct ShortCutProvider: TimelineProvider {
    func placeholder(in context: Context) -> ShortCutEntry {
        ShortCutEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = ShortCutEntry(date: Date())
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let timeline = Timeline(entries: [ShortCutEntry(date: Date())], policy: .never)
        completion(timeline)
    }
}

struct PpuDaeSikShortCutWidget: Widget {
    let kind: String = "PpuDaeSikShortCutWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShortCutProvider()) { entry in
            PpuDaeSikShortCutWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.blue100.ignoresSafeArea()
                }
        }
        .configurationDisplayName("뿌대식")
        .description("귀여워요!")
        .supportedFamilies([.systemSmall])
    }
}

struct ShortCutEntry: TimelineEntry {
    let date: Date
}

struct PpuDaeSikShortCutWidgetEntryView : View {
    var entry: ShortCutEntry
    
    var body: some View {
        ZStack {
            Color.blue100.ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .frame(width: 60, height: 60)
        }
    }
}

#Preview(as: .systemSmall) {
    PpuDaeSikWidget()
} timeline: {
    SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
}
