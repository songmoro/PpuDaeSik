//
//  RestaurantResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct RestaurantResponse: Codable, Hashable, Serializable {
    internal init(integratedRestaurant: IntegratedRestaurant, MENU_DATE: String, MENU_TYPE: String, MENU_TITLE: String, MENU_CONTENT: String, CATEGORY: Category) {
        self.integratedRestaurant = integratedRestaurant
        self.date = MENU_DATE
        self.type = MENU_TYPE
        self.title = MENU_TITLE
        self.content = MENU_CONTENT
        self.category = CATEGORY
    }
    
    init(_ unwrappedValue: [String: String]) {
        self.date = unwrappedValue["MENU_DATE"] ?? ""
        self.type = unwrappedValue["MENU_TYPE"] ?? ""
        self.title = unwrappedValue["MENU_TITLE"] ?? ""
        self.content = unwrappedValue["MENU_CONTENT"] ?? ""
        
        let code = unwrappedValue["RESTAURANT_NAME"] ?? ""
        guard let integratedRestaurant = IntegratedRestaurant(code: code) else {
            fatalError("식당 분류 실패")
        }
        
        self.integratedRestaurant = integratedRestaurant
        self.category = switch self.type {
        case "B": .조식
        case "L": .중식
        case "D": .석식
        default: .조기
        }
    }
    
    /// 옵셔널 초기화
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        
        guard let restaurantCode = properties["restaurantCode"],
              let integratedRestaurant = IntegratedRestaurant(code: restaurantCode),
              let menuDate = properties["menuDate"],
              let menuType = properties["menuType"],
              let menuTitle = properties["menuTitle"],
              let menuContent = properties["menuContent"],
              let category = Category.init(rawValue: menuType)
        else { return nil }

        self.init(integratedRestaurant: integratedRestaurant, MENU_DATE: menuDate, MENU_TYPE: menuType, MENU_TITLE: menuTitle, MENU_CONTENT: menuContent, CATEGORY: category)
    }
    
    var uuid = UUID()
    let integratedRestaurant: IntegratedRestaurant
    let date: String
    let type: String
    let title: String
    let content: String
    let category: Category
}
