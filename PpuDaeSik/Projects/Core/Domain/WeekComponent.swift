//
//  WeekComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct WeekComponent {
    let dayComponent: DayComponent
    let date: Date

    var dayValue: Int {
        Calendar.current.component(.day, from: date)
    }
}

extension WeekComponent {
    /// 오늘을 기준으로 현재 날짜의 WeekComponent를 반환
    static func getToday(using calendar: Calendar = .current, from date: Date = Date()) -> WeekComponent {
        let weekday = calendar.component(.weekday, from: date)
        let dayComponent = DayComponent.from(weekday: weekday)
        return WeekComponent(dayComponent: dayComponent, date: date)
    }
    
    /// 오늘을 기준으로 해당 주(일~토)의 WeekComponent 배열을 계산
    static func calculateCurrentWeek(using calendar: Calendar = .current, from baseDate: Date = Date()) -> [WeekComponent] {
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate)) else {
            fatalError("Failed to compute start of week.")
        }

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { return nil }
            let weekday = calendar.component(.weekday, from: date)
            let dayComponent = DayComponent.from(weekday: weekday)
            return WeekComponent(dayComponent: dayComponent, date: date)
        }
    }
//    static func calculateCurrentWeek(using date: Date = Date()) -> [WeekComponent] {
//        let calendar = Calendar()
//        
//        let weekArray = zip(DayComponent.allCases, calendar.interval()).reduce(into: [WeekComponent]()) { partialResult, weekday in
//            guard let dateComponent = calendar.date(byAdding: .day, value: weekday.1, to: date) else { return }
//            
//            let day = weekday.0
//            let dayComponent = calendar.component(.day, from: dateComponent)
//            
//            partialResult += [WeekComponent(dayComponent: day, dayValue: dayComponent)]
//        }
//        
//        guard weekArray.count == 7, weekArray.map({ $0.dayComponent }) == DayComponent.allCases else {
//            fatalError("Failed to calculate a full week.")
//        }
//        
//        return weekArray
//    }
}

extension WeekComponent: Equatable, Comparable {
    static func == (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.calendarWeekdayIndex == rhs.dayComponent.calendarWeekdayIndex
    }
    
    static func < (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent.calendarWeekdayIndex < rhs.dayComponent.calendarWeekdayIndex
    }
}
