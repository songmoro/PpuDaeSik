//
//  Ext+CustomStringConvertible.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 6/1/25.
//

import Foundation

extension CafeteriaResponse: CustomStringConvertible {
    var description: String {
        "cafeteria: \(cafeteria), date: \(date), category: \(category), title: \(title ?? "nil") content: \(content), breakfastTime: \(breakfastTime ?? "nil"), lunchTime: \(lunchTime ?? "nil"), dinnerTime: \(dinnerTime ?? "nil")"
    }
}

extension RestaurantResponse: CustomStringConvertible {
    var description: String {
        "\(results)"
    }
}

// MARK: Notion Response
extension DormitoryResponse: CustomStringConvertible {
    var description: String {
        "\(results)"
    }
}

extension NotionResponse: CustomStringConvertible {
    var description: String {
        "\(results)"
    }
}

extension Result: CustomStringConvertible {
    var description: String {
        "\(properties)"
    }
}

extension DeploymentProperties: CustomStringConvertible {
    var description: String {
        "DB: \(DB), Status: \(Status)"
    }
}

extension RestaurantProperties: CustomStringConvertible {
    var description: String {
        "RESTAURANT_CODE: \(restaurantCode), MENU_TITLE: \(menuTitle), MENU_DATE: \(menuDate), MENU_TYPE: \(menuType), MENU_CONTENT: \(menuContent), breakfastTime: \(breakfastTime), lunchTime: \(lunchTime), dinnerTime: \(dinnerTime)"
    }
}

extension DomitoryProperties: CustomStringConvertible {
    var description: String {
        "no: \(no), mealDate: \(mealDate), mealkindGcd: \(mealKindGcd), mealNm: \(mealNm)"
    }
}

extension Title: CustomStringConvertible {
    var description: String {
        title.map(\.description).joined(separator: ", ")
    }
}

extension Property: CustomStringConvertible {
    var description: String {
        richText.map(\.description).joined(separator: ", ")
    }
}

extension RichText: CustomStringConvertible {
    var description: String {
        plainText
    }
}
//:-
