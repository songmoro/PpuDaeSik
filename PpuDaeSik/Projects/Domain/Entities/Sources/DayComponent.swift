//
//  DayComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

public enum DayComponent: String, CaseIterable {
    case 일, 월, 화, 수, 목, 금, 토

    private var calendarWeekdayIndex: Int {
        switch self {
        case .일: return 1
        case .월: return 2
        case .화: return 3
        case .수: return 4
        case .목: return 5
        case .금: return 6
        case .토: return 7
        }
    }

    /// weekday: 1 (Sunday) ~ 7 (Saturday)
    static func from(weekday: Int) -> DayComponent {
        return DayComponent.allCases[weekday - 1]
    }
}

extension DayComponent: Equatable, Comparable {
    public static func == (lhs: DayComponent, rhs: DayComponent) -> Bool {
        lhs.calendarWeekdayIndex == rhs.calendarWeekdayIndex
    }
    
    public static func < (lhs: DayComponent, rhs: DayComponent) -> Bool {
        lhs.calendarWeekdayIndex < rhs.calendarWeekdayIndex
    }
}
