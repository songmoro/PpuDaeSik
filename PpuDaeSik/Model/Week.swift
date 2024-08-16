//
//  Week.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct Week: Equatable, Comparable {
    let day: Day
    let dayComponent: Int
    
    static func == (lhs: Week, rhs: Week) -> Bool {
        lhs.day.weekday == rhs.day.weekday
    }
    
    static func < (lhs: Week, rhs: Week) -> Bool {
        lhs.day.weekday < rhs.day.weekday
    }
}
