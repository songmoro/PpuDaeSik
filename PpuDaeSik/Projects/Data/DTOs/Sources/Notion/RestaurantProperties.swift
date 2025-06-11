//
//  RestaurantProperties.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct RestaurantProperties: Codable {
    public let restaurantCode, menuTitle, menuDate, menuType, menuContent: Property
    public let breakfastTime, lunchTime, dinnerTime: Property?
    
    enum CodingKeys: String, CodingKey {
        case restaurantCode = "RESTAURANT_CODE"
        case menuTitle = "MENU_TITLE"
        case menuDate = "MENU_DATE"
        case menuType = "MENU_TYPE"
        case menuContent = "MENU_CONTENT"
        case breakfastTime = "BREAKFAST_TIME"
        case lunchTime = "LUNCH_TIME"
        case dinnerTime = "DINNER_TIME"
    }
}
