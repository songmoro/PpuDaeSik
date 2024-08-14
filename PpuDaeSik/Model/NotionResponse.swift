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

struct DeploymentProperties: Codable, Properties {
    let DB: Title
    let Status: Property
    
    func toDict() -> [String : String] {
        [
            "DB": DB.title[0].plainText,
            "Status": Status.richText[0].plainText
        ]
    }
}

struct RestaurantProperties: Codable, Properties {
    let restaurantCode, menuTitle, menuDate, menuType, menuContent: Property
    
    enum CodingKeys: String, CodingKey {
        case restaurantCode = "RESTAURANT_CODE"
        case menuTitle = "MENU_TITLE"
        case menuDate = "MENU_DATE"
        case menuType = "MENU_TYPE"
        case menuContent = "MENU_CONTENT"
    }
    
    func toDict() -> [String: String] {
        [
            "code": restaurantCode.richText[0].plainText,
            "title": menuTitle.richText[0].plainText,
            "date": menuDate.richText[0].plainText,
            "category": menuType.richText[0].plainText,
            "content": menuContent.richText[0].plainText,
        ]
    }
}

struct DomitoryProperties: Codable, Properties {
    let no: Title
    let mealDate, mealKindGcd, mealNm: Property
    
    func toDict() -> [String: String] {
        [
            "code": no.title[0].plainText,
            "date": mealDate.richText[0].plainText,
            "category": mealKindGcd.richText[0].plainText,
            "content": mealNm.richText[0].plainText
        ]
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
