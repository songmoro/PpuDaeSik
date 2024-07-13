//
//  NotionResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/14/24.
//

import SwiftUI

struct NotionResponse<T: Codable>: Codable {
    let results: [Result<T>]
}

struct Result<T: Codable>: Codable {
    let properties: T
}

struct RestaurantProperties: Codable {
    let restaurantName, menuDate, buildingName: Property
    let breakfastTime, menuContent, dinnerTime: Property
    let restaurantCode, menuTitle, lunchTime, menuType: Property
    let name: Title

    enum CodingKeys: String, CodingKey {
        case restaurantName = "RESTAURANT_NAME"
        case menuDate = "MENU_DATE"
        case buildingName = "BUILDING_NAME"
        case breakfastTime = "BREAKFAST_TIME"
        case menuContent = "MENU_CONTENT"
        case dinnerTime = "DINNER_TIME"
        case restaurantCode = "RESTAURANT_CODE"
        case menuTitle = "MENU_TITLE"
        case lunchTime = "LUNCH_TIME"
        case menuType = "MENU_TYPE"
        case name = "NAME"
    }
}

struct DomitoryProperties: Codable {
    let codeNm, mealNm, mealDate: Property
    let mealKindGcd: Property
    let no: Title
}

struct Title: Codable {
    let title: [RichText]
}

struct Property: Codable {
    let richText: [RichText]

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

struct RichText: Codable {
    let plainText: String

    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}
