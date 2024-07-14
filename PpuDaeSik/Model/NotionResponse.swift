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

struct RestaurantProperties: Codable, Properties {
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
    
    func toDict() -> [String : String] {
        let dict = [
            "restaurantName": restaurantName.richText[0].plainText,
            "menuDate": menuDate.richText[0].plainText,
            "buildingName": buildingName.richText[0].plainText,
            "breakfastTime": breakfastTime.richText[0].plainText,
            "menuContent": menuContent.richText[0].plainText,
            "dinnerTime": dinnerTime.richText[0].plainText,
            "restaurantCode": restaurantCode.richText[0].plainText,
            "menuTitle": menuTitle.richText[0].plainText,
            "lunchTime": lunchTime.richText[0].plainText,
            "menuType": menuType.richText[0].plainText,
            "name": name.title[0].plainText
        ]
        
        return dict
    }
}

struct DomitoryProperties: Codable, Properties {
    let codeNm, mealNm, mealDate: Property
    let mealKindGcd: Property
    let no: Title
    
    func toDict() -> [String : String] {
        let dict = [
            "no": no.title[0].plainText,
            "mealDate": mealDate.richText[0].plainText,
            "mealKindGcd": mealKindGcd.richText[0].plainText,
            "codeNm": codeNm.richText[0].plainText,
            "mealNm": mealNm.richText[0].plainText
        ]
        
        return dict
    }
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
