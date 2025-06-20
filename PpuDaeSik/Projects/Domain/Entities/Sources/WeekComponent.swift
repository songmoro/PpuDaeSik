//
//  WeekComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

public struct WeekComponent {
    public let dayComponent: DayComponent
    private let date: Date
    
    public var dayValue: Int {
        Calendar.current.component(.day, from: date)
    }
}

public extension WeekComponent {
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
}

extension WeekComponent: Equatable, Comparable {
    public static func == (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent == rhs.dayComponent
    }
    
    public static func < (lhs: WeekComponent, rhs: WeekComponent) -> Bool {
        lhs.dayComponent < rhs.dayComponent
    }
}
