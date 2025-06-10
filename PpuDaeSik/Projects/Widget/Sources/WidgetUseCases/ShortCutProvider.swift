//
//  ShortCutProvider.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import WidgetKit

struct ShortCutProvider: TimelineProvider {
    typealias Entry = ShortCutEntry
    
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
