//
//  Week.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct Week: Comparable {
    static func < (lhs: Week, rhs: Week) -> Bool {
        lhs.day.weekday < rhs.day.weekday
    }
    
    let day: Day
    let dayComponent: Int
}
