//
//  Model.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/9/24.
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
}

enum Week: String, CaseIterable {
    case 일, 월, 화, 수, 목, 금, 토
    
    func weekday() -> Int {
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

enum Category: String, CaseIterable, Hashable, Codable {
    case 조기, 조식, 중식, 석식
    
    func order() -> Int {
        switch self {
        case .조기: 0
        case .조식: 1
        case .중식: 2
        case .석식: 3
        }
    }
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

enum QueryType: String, CaseIterable {
    case restaurant, domitory
}

enum Domitory: Int, CaseIterable, Hashable, Codable {
    case 진리관 = 2
    case 비마관 = 3
    case 웅비관 = 11
    case 행림관 = 12
    case 자유관 = 13
    
    func order() -> Int {
        switch self {
        case .진리관: 0
        case .웅비관: 1
        case .자유관: 2
        case .비마관: 3
        case .행림관: 4
        }
    }
    
    func campus() -> Campus {
        switch self {
        case .진리관, .웅비관, .자유관: Campus.부산
        case .비마관: Campus.밀양
        case .행림관: Campus.양산
        }
    }
    
    func code() -> String {
        switch self {
        case .진리관: "2"
        case .웅비관: "11"
        case .자유관: "13"
        case .비마관: "3"
        case .행림관: "12"
        }
    }
    
    func name() -> String {
        switch self {
        case .진리관: "진리관"
        case .웅비관: "웅비관"
        case .자유관: "자유관"
        case .비마관: "비마관"
        case .행림관: "행림관"
        }
    }
}

struct DomitoryResponse: Codable {
    init(unwrappedValue: [String: String]) {
        self.no = unwrappedValue["no"] ?? ""
        self.mealDate = unwrappedValue["mealDate"] ?? ""
        self.mealKindGcd = unwrappedValue["mealKindGcd"] ?? ""
        self.codeNm = unwrappedValue["codeNm"] ?? ""
        self.mealNm = unwrappedValue["mealNm"] ?? ""
        
        self.campus = switch self.no {
        case "2", "11", "13": .부산
        case "3": .밀양
        case "12": .양산
        default: .부산
        }
        self.domitory = Domitory(rawValue: Int(self.no)!)!
        self.category = switch self.mealKindGcd {
        case "01": .조기
        case "02": .조식
        case "03": .중식
        case "04": .석식
        default: .조기
        }
    }
    
    var uuid = UUID()
    var no: String
    var mealDate: String
    var mealKindGcd: String
    var codeNm: String
    var mealNm: String
    var campus: Campus
    var domitory: Domitory
    var category: Category
}

enum Restaurant: String, CaseIterable, Hashable, Codable {
    case 금정회관교직원식당 = "금정회관 교직원 식당"
    case 금정회관학생식당 = "금정회관 학생 식당"
    case 샛벌회관식당 = "샛벌회관 식당"
    case 학생회관학생식당 = "학생회관 학생 식당"
    case 학생회관밀양학생식당 = "학생회관(밀양) 학생 식당"
    case 학생회관밀양교직원식당 = "학생회관(밀양) 교직원 식당"
    case 편의동2층양산식당 = "편의동2층(양산) 식당"
    
    func order() -> Int {
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
    
    func campus() -> Campus {
        switch self {
        case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당:
            Campus.부산
        case .학생회관밀양학생식당, .학생회관밀양교직원식당:
            Campus.밀양
        case .편의동2층양산식당:
            Campus.양산
        }
    }
    
    func code() -> String {
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
}

struct RestaurantResponse: Codable, Hashable {
    init(unwrappedValue: [String: String]) {
        self.NAME = (unwrappedValue["BUILDING_NAME"] ?? "") + " " + (unwrappedValue["RESTAURANT_NAME"] ?? "")
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
        
        self.RESTAURANT = Restaurant(rawValue: self.NAME) ?? .금정회관교직원식당
        self.CAMPUS = switch self.RESTAURANT_CODE {
        case "PG001", "PG002", "PS001", "PH002":
                .부산
        case "M001", "M002":
                .밀양
        case "Y001":
                .양산
        default:
                .부산
        }
        self.CATEGORY = switch self.MENU_TYPE {
        case "B": .조식
        case "L": .중식
        case "D": .석식
        default: .조기
        }
    }
    
    var uuid = UUID()
    var NAME: String
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
    var CAMPUS: Campus
    var RESTAURANT: Restaurant
    var CATEGORY: Category
}

struct CheckDatabase: Codable {
    var results: [CheckProperties]
    
    struct CheckProperties: Codable {
        var properties: [String: CheckProperty]
        
        struct CheckProperty: Codable {
            var type: String
            var title: [RichText]?
            var rich_text: [RichText]?
            
            struct RichText: Codable {
                var plain_text: String
            }
        }
    }
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

struct FilterByCampusRequest: Codable {
    init(property: String, campus: Campus, date: [String]) {
        var code: [Filter.Or.ConditionalExpression]
        
        if property == "MENU_DATE" {
            code = campus.restaurant.map { c in
                Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: c.code()))
            }
        }
        else {
            code = campus.domitory.map { c in
                Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: c.code()))
            }
        }
        
        let condition = date.map { d in
            Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: d))
        }
        
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: condition)])
    }
    
    init(property: String, name: String, date: String, category: [String]) {
        var code: [Filter.Or.ConditionalExpression]
        var categoryType: [Filter.Or.ConditionalExpression]
        
        if property == "MENU_DATE" {
            code = [Filter.Or.ConditionalExpression(property: "RESTAURANT_CODE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = category.map {
                Filter.Or.ConditionalExpression(property: "MENU_TYPE", rich_text: Filter.Or.ConditionalExpression.RichText(equals: $0))
            }
        }
        else {
            code = [Filter.Or.ConditionalExpression(property: "no", rich_text: Filter.Or.ConditionalExpression.RichText(equals: name))]
            categoryType = category.map {
                 Filter.Or.ConditionalExpression(property: "mealKindGcd", rich_text: Filter.Or.ConditionalExpression.RichText(equals: $0))
            }
        }
        
        let condition = Filter.Or.ConditionalExpression(property: property, rich_text: Filter.Or.ConditionalExpression.RichText(equals: date))
        
        
        self.filter = Filter(and: [Filter.Or(or: code), Filter.Or(or: [condition]), Filter.Or(or: categoryType)])
    }
    
    var filter: Filter
    
    struct Filter: Codable {
        var and: [Or]
        
        struct Or: Codable {
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
}
