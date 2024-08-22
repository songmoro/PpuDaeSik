//
//  WeekComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct WeekComponent: Equatable, Comparable {
    let dayComponent: DayComponent
    let dayValue: Int
    
    static func == (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.weekday == rhs.dayComponent.weekday
    }
    
    static func < (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.weekday < rhs.dayComponent.weekday
    }
    
    static var today: WeekComponent? {
        let calendar = Calendar()
        
        let dayComponent = DayComponent.allCases[Calendar.current.component(.weekday, from: Date()) - 1]
        guard let date = calendar.date(byAdding: .day, value: dayComponent.weekday, to: Date()) else { return nil }
        
        return WeekComponent(dayComponent: dayComponent, dayValue: calendar.component(.day, from: date))
    }
}
