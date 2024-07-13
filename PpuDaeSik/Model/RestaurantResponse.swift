//
//  RestaurantResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct RestaurantResponse: Codable, Hashable, Serializable {
    init(_ unwrappedValue: [String: String]) {
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
