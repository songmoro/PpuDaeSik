//
//  WeekComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct WeekComponent {
    let dayComponent: DayComponent
    let dayValue: Int
    
    static var today: WeekComponent? {
        let calendar = Calendar()
        let dayComponent = DayComponent.allCases[Calendar.current.component(.weekday, from: Date()) - 1]
        
        return WeekComponent(dayComponent: dayComponent, dayValue: calendar.component(.day, from: Date()))
    }
    
    /// 오늘 날짜를 기준으로 이번 주를 계산하고 할당
    static func calculateCurrentWeek() -> [WeekComponent] {
        let calendar = Calendar()
        
        let weekArray = zip(DayComponent.allCases, calendar.interval()).reduce(into: [WeekComponent]()) { partialResult, weekday in
            guard let date = calendar.date(byAdding: .day, value: weekday.1, to: Date()) else { return }
            
            let day = weekday.0
            let dayComponent = calendar.component(.day, from: date)
            
            partialResult += [WeekComponent(dayComponent: day, dayValue: dayComponent)]
        }
        
        guard weekArray.count == 7, weekArray.map({ $0.dayComponent }) == DayComponent.allCases else {
            fatalError()
        }
        
        return weekArray
    }
}

extension WeekComponent: Equatable, Comparable {
    static func == (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.weekday == rhs.dayComponent.weekday
    }
    
    static func < (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.weekday < rhs.dayComponent.weekday
    }
}
