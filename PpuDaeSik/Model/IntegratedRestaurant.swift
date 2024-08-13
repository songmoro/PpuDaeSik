//
//  IntegratedRestaurant.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/13/24.
//

import SwiftUI

/// 기숙사, 식당 통합한 enum
enum IntegratedRestaurant: Codable {
    /// 학생 식당
    case 금정회관교직원식당, 금정회관학생식당, 샛벌회관식당, 학생회관학생식당, 학생회관밀양학생식당, 학생회관밀양교직원식당, 편의동2층양산식당
    /// 기숙사
    case 진리관, 웅비관, 자유관, 비마관, 행림관
    
    /// 건물 구분 코드
    var code: String {
        switch self {
        case .금정회관교직원식당: "PG001"
        case .금정회관학생식당: "PG002"
        case .샛벌회관식당: "PS001"
        case .학생회관학생식당: "PH002"
        case .학생회관밀양학생식당: "M001"
        case .학생회관밀양교직원식당: "M002"
        case .편의동2층양산식당: "Y001"
        case .진리관: "2"
        case .웅비관: "11"
        case .자유관: "13"
        case .비마관: "3"
        case .행림관: "12"
        }
    }
    
    /// 짧은 식당 이름
    var shortName: String {
        switch self {
        case .금정회관교직원식당: "금정 교직원"
        case .금정회관학생식당: "금정 학생"
        case .샛벌회관식당: "샛벌회관"
        case .학생회관학생식당: "학생회관"
        case .학생회관밀양학생식당: "밀양 학생"
        case .학생회관밀양교직원식당: "밀양 교직원"
        case .편의동2층양산식당: "편의동"
        case .진리관: "진리관"
        case .웅비관: "웅비관"
        case .자유관: "자유관"
        case .비마관: "비마관"
        case .행림관: "행림관"
        }
    }
    
    /// 식당 이름
    var name: String {
        switch self {
//        case .금정회관교직원식당: "금정회관 교직원 식당"
//        case .금정회관학생식당: "금정회관 학생 식당"
//        case .샛벌회관식당: "샛벌회관"
//        case .학생회관학생식당: "학생회관 학생 식당"
//        case .학생회관밀양학생식당: "학생회관(밀양) 학생 식당"
//        case .학생회관밀양교직원식당: "학생회관(밀양) 교직원 식당"
//        case .편의동2층양산식당: "편의동2층(양산)"
//        case .진리관: "진리관"
//        case .웅비관: "웅비관"
//        case .자유관: "자유관"
//        case .비마관: "비마관"
//        case .행림관: "행림관"
        case .금정회관교직원식당: "금정회관 교직원 식당"
        case .금정회관학생식당: "금정회관 학생 식당"
        case .샛벌회관식당: "샛벌회관 식당"
        case .학생회관학생식당: "학생회관 학생 식당"
        case .학생회관밀양학생식당: "학생회관(밀양) 학생 식당"
        case .학생회관밀양교직원식당: "학생회관(밀양) 교직원 식당"
        case .편의동2층양산식당: "편의동2층(양산) 식당"
        case .진리관: "진리관"
        case .웅비관: "웅비관"
        case .자유관: "자유관"
        case .비마관: "비마관"
        case .행림관: "행림관"
        }
    }
    
    /// 캠퍼스 위치
    var campus: Campus {
        switch self {
        case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .진리관, .웅비관, .자유관:
            Campus.부산
        case .학생회관밀양학생식당, .학생회관밀양교직원식당, .비마관:
            Campus.밀양
        case .편의동2층양산식당, .행림관:
            Campus.양산
        }
    }
    
    /// 옵셔널 초기화
    init?(code: String) {
        let restaurant: IntegratedRestaurant? = switch code {
        case "PG001": .금정회관교직원식당
        case "PG002": .금정회관학생식당
        case "PS001": .샛벌회관식당
        case "PH002": .학생회관학생식당
        case "M001": .학생회관밀양학생식당
        case "M002": .학생회관밀양교직원식당
        case "Y001": .편의동2층양산식당
        case "2": .진리관
        case "11": .웅비관
        case "13": .자유관
        case "3": .비마관
        case "12": .행림관
        default: nil
        }
        
        guard let restaurant = restaurant else { return nil }
        self = restaurant
    }
}
