//
//  Model.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/9/24.
//

import SwiftUI

enum Campus: String, CaseIterable {
    case 부산, 밀양, 양산
    
    var restaurant: [Restaurant] {
        switch self {
        case .부산:
            [Restaurant.금정회관학생, Restaurant.금정회관교직원, Restaurant.샛벌회관, Restaurant.학생회관학생, Restaurant.진리관, Restaurant.웅비관, Restaurant.자유관]
        case .밀양:
            [Restaurant.학생회관학생, Restaurant.학생회관교직원, Restaurant.비마관]
        case .양산:
            [Restaurant.편의동, Restaurant.행림관]
        }
    }
}

enum Week: String, CaseIterable {
    case 일, 월, 화, 수, 목, 금, 토
}

enum Category: String, CaseIterable, Hashable {
    case 조식, 중식, 석식
}

enum Restaurant: String, CaseIterable, Hashable {
    case 금정회관학생 = "금정회관 학생"
    case 금정회관교직원 = "금정회관 교직원"
    case 샛벌회관
    case 학생회관학생 = "학생회관 학생"
    case 진리관
    case 웅비관
    case 자유관
    // 학생회관 학생
    case 학생회관교직원 = "학생회관 교직원"
    case 비마관
    case 편의동
    case 행림관
}

struct Meal: Hashable {
    var foodByCategory: [Category: String] = [:]
}

struct QueryDatabase: Codable {
    var results: [QueryProperties]
    
    struct QueryProperties: Codable {
        var properties: [String: QueryProperty]

        struct QueryProperty: Codable {
            var type: String
            var rich_text: [RichText]?
            var select: [String: String]?
            
            struct RichText: Codable {
                var plain_text: String
            }
        }
    }
}
