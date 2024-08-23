//
//  DayComponent.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

enum DayComponent: String, CaseIterable {
    case 일, 월, 화, 수, 목, 금, 토
    
    var weekday: Int {
        switch self {
        case .일: 1
        case .월: 2
        case .화: 3
        case .수: 4
        case .목: 5
        case .금: 6
        case .토: 7
        }
    }
}
