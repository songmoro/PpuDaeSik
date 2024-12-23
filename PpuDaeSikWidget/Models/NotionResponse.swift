//
//  NotionResponse.swift
//  PpuDaeSikWidgetExtension
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

struct RestaurantResponse: NotionResponseAble, CustomStringConvertible {
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
        
        guard let cafeteria, let category else { return nil }
        return CafeteriaResponse(cafeteria: cafeteria, date: date, category: category, title: title, content: content)
    }
    
    var description: String {
        "\(results)"
    }
}

struct DormitoryResponse: NotionResponseAble, CafeteriaAble, CustomStringConvertible {
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
    
    var description: String {
        "\(results)"
    }
}

struct NotionResponse<T: Codable>: Codable, CustomStringConvertible {
    let results: [Result<T>]
    
    var description: String {
        "\(results)"
    }
}

struct Result<T: Codable>: Codable, CustomStringConvertible {
    let properties: T
    
    var description: String {
        "\(properties)"
    }
}

struct DeploymentProperties: Codable, CustomStringConvertible {
    let DB: Title
    let Status: Property
    
    var description: String {
        "DB: \(DB), Status: \(Status)"
    }
}

struct RestaurantProperties: Codable, CustomStringConvertible {
    let restaurantCode, menuTitle, menuDate, menuType, menuContent: Property
    
    enum CodingKeys: String, CodingKey {
        case restaurantCode = "RESTAURANT_CODE"
        case menuTitle = "MENU_TITLE"
        case menuDate = "MENU_DATE"
        case menuType = "MENU_TYPE"
        case menuContent = "MENU_CONTENT"
    }
    
    var description: String {
        "RESTAURANT_CODE: \(restaurantCode), MENU_TITLE: \(menuTitle), MENU_DATE: \(menuDate), MENU_TYPE: \(menuType), MENU_CONTENT: \(menuContent)"
    }
}

struct DomitoryProperties: Codable, CustomStringConvertible {
    let no: Title
    let mealDate, mealKindGcd, mealNm: Property
    
    var description: String {
        "no: \(no), mealDate: \(mealDate), mealkindGcd: \(mealKindGcd), mealNm: \(mealNm)"
    }
}

struct Title: Codable, CustomStringConvertible {
    let title: [RichText]
    
    var description: String {
        title.map(\.description).joined(separator: ", ")
    }
}

struct Property: Codable, CustomStringConvertible {
    let richText: [RichText]
    
    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
    
    var description: String {
        richText.map(\.description).joined(separator: ", ")
    }
}

struct RichText: Codable, CustomStringConvertible {
    let plainText: String
    
    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
    
    var description: String {
        plainText
    }
}
