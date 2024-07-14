//
//  Campus.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Campus: String, CaseIterable, Codable {
    case 부산, 밀양, 양산
    
    var restaurant: [Restaurant] {
        switch self {
        case .부산:
            [.금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당]
        case .밀양:
            [.학생회관밀양학생식당, .학생회관밀양교직원식당]
        case .양산:
            [.편의동2층양산식당]
        }
    }
    
    var domitory: [Domitory] {
        switch self {
        case .부산:
            [.진리관, .웅비관, .자유관]
        case .밀양:
            [.비마관]
        case .양산:
            [.행림관]
        }
    }
    
    static func getCampus(no: String) -> Self {
        switch Int(no) {
        case 2, 11, 13: .부산
        case 3: .밀양
        case 12: .양산
        default: .부산
        }
    }
    
    static func getCampus(code: String) -> Self {
        switch code {
        case "PG001", "PG002", "PS001", "PH002": .부산
        case "M001", "M002": .밀양
        case "Y001": .양산
        default: .부산
        }
    }
}
