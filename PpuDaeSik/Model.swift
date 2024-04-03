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
            [Restaurant.금정회관학생, Restaurant.금정회관교직원, Restaurant.샛벌회관, Restaurant.학생회관장전학생, Restaurant.진리관, Restaurant.웅비관, Restaurant.자유관]
        case .밀양:
            [Restaurant.학생회관밀양학생, Restaurant.학생회관밀양교직원, Restaurant.비마관]
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
    case 학생회관장전학생 = "학생회관(장전) 학생"
    case 진리관
    case 웅비관
    case 자유관
    case 학생회관밀양학생 = "학생회관(밀양) 학생"
    case 학생회관밀양교직원 = "학생회관(밀양) 교직원"
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
            var title: [RichText]?
            var rich_text: [RichText]?
            
            struct RichText: Codable {
                var plain_text: String
            }
        }
    }
}

enum Domitory: Int, CaseIterable, Hashable {
    case 진리관 = 2
    case 웅비관 = 11
    case 자유관 = 13
    case 비마관 = 3
    case 행림관 = 12
}

struct DomitoryResponse: Codable {
    var mealDate: String
    var mealKindGcd: String
    var codeNm: String
    var mealNm: String
}

enum NewRestaurant: String, CaseIterable, Hashable {
    case 금정회관교직원식당 = "금정회관 교직원 식당"
    case 금정회관학생식당 = "금정회관 학생 식당"
    case 샛벌회관식당 = "샛벌회관 식당"
    case 학생회관학생식당 = "학생회관 학생 식당"
    case 학생회관밀양학생식당 = "학생회관(밀양) 학생 식당"
    case 학생회관밀양교직원식당 = "학생회관(밀양) 교직원 식당"
    case 편의동2층양산식당 = "편의동 2층(양산) 식당"
}

struct NewRestaurantResponse: Codable {
    init(unwrappedValue: [String: String]) {
        self.MENU_DATE = unwrappedValue["MENU_DATE"] ?? ""
        self.BUILDING_NAME = unwrappedValue["BUILDING_NAME"] ?? ""
        self.RESTAURANT_NAME = unwrappedValue["RESTAURANT_NAME"] ?? ""
        self.RESTAURANT_CODE = unwrappedValue["RESTAURANT_CODE"] ?? ""
        self.MENU_TYPE = unwrappedValue["MENU_TYPE"] ?? ""
        self.MENU_TITLE = unwrappedValue["MENU_TITLE"] ?? ""
        self.MENU_CONTENT = unwrappedValue["MENU_CONTENT"] ?? ""
        self.BREAKFAST_TIME = unwrappedValue["BREAKFAST_TIME"] ?? ""
        self.LUNCH_TIME = unwrappedValue["LUNCH_TIME"] ?? ""
        self.DINNER_TIME = unwrappedValue["DINNER_TIME"] ?? ""
        self.TEL = unwrappedValue["TEL"] ?? ""
    }
    
    var MENU_DATE: String
    var BUILDING_NAME: String
    var RESTAURANT_NAME: String
    var RESTAURANT_CODE: String
    var MENU_TYPE: String
    var MENU_TITLE: String
    var MENU_CONTENT: String
    var BREAKFAST_TIME: String
    var LUNCH_TIME: String
    var DINNER_TIME: String
    var TEL: String
}


struct FilterRequest: Codable {
    init(property: String, date: [String]) {
        let condition = date.map { d in
            Filter.ConditionalExpression(property: property, rich_text: Filter.ConditionalExpression.RichText(equals: d))
        }
        
        self.filter = Filter(or: condition)
    }
    
    var filter: Filter
    
    struct Filter: Codable {
        var or: [ConditionalExpression]
        
        struct ConditionalExpression: Codable {
            var property: String
            var rich_text: RichText
            
            struct RichText: Codable {
                var equals: String
            }
        }
    }
}
