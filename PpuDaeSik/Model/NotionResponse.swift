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
    let menuDate, menuType: Property
    let restaurantCode, menuTitle, menuContent: Property
    
    enum CodingKeys: String, CodingKey {
        case menuDate = "MENU_DATE"
        case menuContent = "MENU_CONTENT"
        case restaurantCode = "RESTAURANT_CODE"
        case menuTitle = "MENU_TITLE"
        case menuType = "MENU_TYPE"
    }
    
    func toDict() -> [String : String] {
        [
            "menuDate": menuDate.richText[0].plainText,
            "menuContent": menuContent.richText[0].plainText,
            "restaurantCode": restaurantCode.richText[0].plainText,
            "menuTitle": menuTitle.richText[0].plainText,
            "menuType": menuType.richText[0].plainText,
        ]
    }
}

struct DomitoryProperties: Codable, Properties {
    let codeNm, mealNm, mealDate: Property
    let mealKindGcd: Property
    let no: Title
    
    func toDict() -> [String : String] {
        [
            "no": no.title[0].plainText,
            "mealDate": mealDate.richText[0].plainText,
            "mealKindGcd": mealKindGcd.richText[0].plainText,
            "codeNm": codeNm.richText[0].plainText,
            "mealNm": mealNm.richText[0].plainText
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
