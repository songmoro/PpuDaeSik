//
//  Provider.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import SwiftUI
import WidgetKit
import Entities

struct Provider: IntentTimelineProvider {
    let widgetRepository: WidgetRepository
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        guard let cafeteria = configuration.getCafeteria(),
              let category = configuration.getCategory()
        else { return }
        
        let currentDate = Date()
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        Task {
            let menu = await widgetRepository.fetch(cafeteria: cafeteria, category: category)
            
            if let menu = menu {
                let shortName = menu.cafeteria.shortName
                let content = menu.content
                
                let entry = SimpleEntry(configuration: configuration, date: currentDate, name: shortName, category: Category(category)?.rawValue ?? category, meal: content)
                let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                
                completion(timeline)
            }
            else {
                let entry = SimpleEntry(configuration: configuration, date: currentDate, name: cafeteria.shortName, category: category, meal: "메뉴가 존재하지 않아요.")
                let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                
                completion(timeline)
            }
        }
    }
}
