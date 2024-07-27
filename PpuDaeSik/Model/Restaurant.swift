//
//  Restaurant.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

enum Restaurant: String, CaseIterable, Hashable, Codable {
    case 금정회관교직원식당 = "금정회관 교직원 식당"
    case 금정회관학생식당 = "금정회관 학생 식당"
    case 샛벌회관식당 = "샛벌회관 식당"
    case 학생회관학생식당 = "학생회관 학생 식당"
    case 학생회관밀양학생식당 = "학생회관(밀양) 학생 식당"
    case 학생회관밀양교직원식당 = "학생회관(밀양) 교직원 식당"
    case 편의동2층양산식당 = "편의동2층(양산) 식당"
    
    var order: Int {
        switch self {
        case .금정회관교직원식당: 0
        case .금정회관학생식당: 1
        case .샛벌회관식당: 2
        case .학생회관학생식당: 3
        case .학생회관밀양학생식당: 4
        case .학생회관밀양교직원식당: 5
        case .편의동2층양산식당: 6
        }
    }
    
    var campus: Campus {
        switch self {
        case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당:
            Campus.부산
        case .학생회관밀양학생식당, .학생회관밀양교직원식당:
            Campus.밀양
        case .편의동2층양산식당:
            Campus.양산
        }
    }
    
    var code: String {
        switch self {
        case .금정회관교직원식당: "PG001"
        case .금정회관학생식당: "PG002"
        case .샛벌회관식당: "PS001"
        case .학생회관학생식당: "PH002"
        case .학생회관밀양학생식당: "M001"
        case .학생회관밀양교직원식당: "M002"
        case .편의동2층양산식당: "Y001"
        }
    }
    
    var shortName: String {
        switch self {
        case .금정회관교직원식당:
            "금정 교직원"
        case .금정회관학생식당:
            "금정 학생"
        case .샛벌회관식당:
            "샛벌회관"
        case .학생회관학생식당:
            "학생회관"
        case .학생회관밀양학생식당:
            "밀양 학생"
        case .학생회관밀양교직원식당:
            "밀양 교직원"
        case .편의동2층양산식당:
            "편의동"
        }
    }
    
    static func getRestaurant(_ name: String) -> Self {
        Restaurant(rawValue: name) ?? .금정회관교직원식당
    }
}
