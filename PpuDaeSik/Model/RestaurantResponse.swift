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
    
    init(_ NAME: String, _ MENU_DATE: String, _ BUILDING_NAME: String, _ RESTAURANT_NAME: String, _ RESTAURANT_CODE: String, _ MENU_TYPE: String, _ MENU_TITLE: String, _ MENU_CONTENT: String, _ BREAKFAST_TIME: String, _ LUNCH_TIME: String, _ DINNER_TIME: String, _ TEL: String, _ CAMPUS: Campus, _ RESTAURANT: Restaurant, _ CATEGORY: Category) {
        self.NAME = NAME
        self.MENU_DATE = MENU_DATE
        self.BUILDING_NAME = BUILDING_NAME
        self.RESTAURANT_NAME = RESTAURANT_NAME
        self.RESTAURANT_CODE = RESTAURANT_CODE
        self.MENU_TYPE = MENU_TYPE
        self.MENU_TITLE = MENU_TITLE
        self.MENU_CONTENT = MENU_CONTENT
        self.BREAKFAST_TIME = BREAKFAST_TIME
        self.LUNCH_TIME = LUNCH_TIME
        self.DINNER_TIME = DINNER_TIME
        self.TEL = TEL
        self.CAMPUS = CAMPUS
        self.RESTAURANT = RESTAURANT
        self.CATEGORY = CATEGORY
    }
    
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        
        guard let name = properties["name"],
              let menuDate = properties["menuDate"],
              let buildingName = properties["buildingName"],
              let restaurantName = properties["restaurantName"],
              let restaurantCode = properties["restaurantCode"],
              let menuType = properties["menuType"],
              let menuTitle = properties["menuTitle"],
              let menuContent = properties["menuContent"],
              let breakfastTime = properties["breakfastTime"],
              let lunchTime = properties["lunchTime"],
              let dinnerTime = properties["dinnerTime"]
        else { return nil }

        self.init(
            name, menuDate, buildingName, restaurantName, restaurantCode, menuType, menuTitle, menuContent, breakfastTime, lunchTime, dinnerTime, "",
            Campus.getCampus(code: restaurantCode),
            Restaurant.getRestaurant(restaurantName),
            Category.getCategory(menuType: menuType)
        )
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
