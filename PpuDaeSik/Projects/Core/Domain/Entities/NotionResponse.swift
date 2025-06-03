//
//  NotionResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/14/24.
//

import SwiftUI

protocol NotionResponseAble: Codable {
    associatedtype resultType: Codable
    
    var results: [Result<resultType>] { get }
}

protocol CafeteriaAble {
    func convertToCafeteria() -> [CafeteriaResponse]
}

struct DeploymentResponse: NotionResponseAble {
    typealias resultType = DeploymentProperties
    
    var results: [Result<resultType>]
}

struct RestaurantResponse: NotionResponseAble {
    typealias resultType = RestaurantProperties
    
    var results: [Result<resultType>]
    
    func convertToCafeteria() -> [CafeteriaResponse] {
        results.compactMap {
            convert(properties: $0.properties)
        }
    }
    
    private func convert(properties: RestaurantProperties) -> CafeteriaResponse? {
        let code = properties.restaurantCode.richText[0].plainText
        let cafeteria = Cafeteria(code)
        let title = properties.menuTitle.richText[0].plainText
        let date = properties.menuDate.richText[0].plainText
        let rawCategory = properties.menuType.richText[0].plainText
        let category = Category(rawCategory)
        let content = properties.menuContent.richText[0].plainText
        let breakfastTime = properties.breakfastTime?.richText[0].plainText
        let lunchTime = properties.lunchTime?.richText[0].plainText
        let dinnerTime = properties.dinnerTime?.richText[0].plainText
        
        guard let cafeteria, let category else { return nil }
        return CafeteriaResponse(cafeteria: cafeteria, date: date, category: category, title: title, content: content, breakfastTime: breakfastTime, lunchTime: lunchTime, dinnerTime: dinnerTime)
    }
}

struct DormitoryResponse: NotionResponseAble, CafeteriaAble {
    typealias resultType = DomitoryProperties
    
    var results: [Result<resultType>]
    
    func convertToCafeteria() -> [CafeteriaResponse] {
        results.compactMap {
            convert(properties: $0.properties)
        }
    }
    
    private func convert(properties: DomitoryProperties) -> CafeteriaResponse? {
        let code = properties.no.title[0].plainText
        let cafeteria = Cafeteria(code)
        let date = properties.mealDate.richText[0].plainText
        let rawCategory = properties.mealKindGcd.richText[0].plainText
        let category = Category(rawCategory)
        let content = properties.mealNm.richText[0].plainText
        
        guard let cafeteria, let category else { return nil }
        return CafeteriaResponse(cafeteria: cafeteria, date: date, category: category, content: content)
    }
}

struct NotionResponse<T: Codable>: Codable {
    let results: [Result<T>]
}

struct Result<T: Codable>: Codable {
    let properties: T
}

struct DeploymentProperties: Codable {
    let DB: Title
    let Status: Property
}

struct RestaurantProperties: Codable {
    let restaurantCode, menuTitle, menuDate, menuType, menuContent: Property
    let breakfastTime, lunchTime, dinnerTime: Property?
    
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

struct DomitoryProperties: Codable {
    let no: Title
    let mealDate, mealKindGcd, mealNm: Property
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
