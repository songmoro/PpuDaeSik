//
//  Campus.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Campus: String, CaseIterable, Codable {
    case 부산, 밀양, 양산
    
    init?(_ rawValue: String) {
        let campus: Campus? = switch rawValue {
        case "부산": .부산
        case "밀양": .밀양
        case "양산": .양산
        default: nil
        }
        
        guard let campus = campus else { return nil }
        self = campus
    }
}
