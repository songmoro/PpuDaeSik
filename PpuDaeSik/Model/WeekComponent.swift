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
}
