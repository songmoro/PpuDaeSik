//
//  PpuDaeSikWidget.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 5/3/24.
//

import WidgetKit
import SwiftUI
import Shared

struct PpuDaeSikWidget: Widget {
    let kind: String = "PpuDaeSikWidget"
    let provider: Provider = Provider(widgetRepository: WidgetRepositoryImpl(session: URLSession.shared))
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: provider) { entry in
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

#Preview(as: .systemSmall) {
    PpuDaeSikWidget()
} timeline: {
    SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
}
